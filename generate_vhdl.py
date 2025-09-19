import xml.etree.ElementTree as ET

def print_xml_structure(file_path):
    tree = ET.parse(file_path)
    root = tree.getroot()

    # Recursive function to print the XML structure
    def print_elements(elem, level=0):
        indent = "  " * level
        print(f"{indent}Tag: {elem.tag}, Attributes: {elem.attrib}")
        for child in elem:
            print_elements(child, level + 1)

    print("Root Element:", root.tag)
    print("XML Structure:")
    print_elements(root)


def parse_dfa(file_path):
    tree = ET.parse(file_path)
    root = tree.getroot()

    # Find the automaton tag
    automaton = root.find('automaton')

    # Ensure automaton tag exists
    if automaton is None:
        raise ValueError("No 'automaton' tag found in the XML.")

    states = []
    transitions = []

    # Extract states from automaton
    for state in automaton.findall('state'):
        state_id = state.get('id')
        state_name = state.get('name')

        # Handle the 'initial' and 'final' attributes
        is_initial = state.find('initial') is not None  # 'initial' tag presence
        is_final = state.find('final') is not None  # 'final' tag presence

        # Add state information
        states.append({
            "id": state_id,
            "name": state_name,
            "initial": is_initial,
            "final": is_final,
        })

    # Extract transitions from automaton
    for transition in automaton.findall('transition'):
        frm = transition.find('from').text
        to = transition.find('to').text
        read = transition.find('read').text
        transitions.append({
            "from": frm,
            "to": to,
            "read": read
        })

    return {"states": states, "transitions": transitions}

# Generate VHDL code from parsed DFA
def generate_vhdl(dfa):
    vhdl_code = """
-- VHDL code for the DFA FSM
-- Joshua Tewolde | Kettering University | 2025
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity dfa_fsm is
    Port (
        FPGA_clk	: in	STD_LOGIC;
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        input_bit : in STD_LOGIC;
        state_out : out STD_LOGIC_VECTOR(7 downto 0)
    );
end dfa_fsm;

architecture Behavioral of dfa_fsm is
"""

    # Define states
    state_names = [state['name'] for state in dfa['states']]
    vhdl_code += "    type state_type is (" + ", ".join(state_names) + ");\n\n"

    vhdl_code += """
    signal current_state: state_type := q0;
    signal next_state: state_type;
    signal finished : STD_LOGIC := '0';
    signal prev_reset : STD_LOGIC := '0'; -- To detect falling edge of reset
    signal prev_clk	:	STD_LOGIC := '0';


begin
    process(FPGA_clk)
    begin
		if rising_edge(FPGA_clk) then
			if prev_reset = '1' AND reset = '0' then --on reset
				prev_reset <= '0';
				finished <= '0';
				current_state <= q0;
			elsif prev_reset = '0' AND reset = '1' then
				prev_reset <= '1';
				finished <= '1';
			elsif finished <= '0'  then
				prev_reset <= reset;
			end if;
			
			if prev_clk = '0' AND clk = '1' then --clk pressed
				current_state <= next_state;
				prev_clk <= '1';
			end if;
			
			prev_clk <= clk;
		end if;
    end process;

    -- transition logic
    process(current_state, input_bit)
    begin
        case current_state is
"""

    # State transition logic
    for state in dfa['states']:
        vhdl_code += f"            when {state['name']} =>\n"
        for transition in dfa['transitions']:
            if transition["from"] == state["id"]:
                vhdl_code += f"                if input_bit = '{transition['read']}' then\n"
                vhdl_code += f"                    next_state <= {dfa['states'][int(transition['to'])]['name']};\n"
                vhdl_code += "                end if;\n"

    vhdl_code += """
        end case;
    end process;
    
    -- Encode state to output
    process(current_state, finished)
    begin
		if finished = '1' then\n"""
    # Build a list of final states
    final_states = [state['id'] for state in dfa['states'] if state['final']]

    # Dynamically generate the VHDL condition for checking final states
    vhdl_code += "        if current_state = q" + final_states[0]
    for final_state in final_states[1:]:
        vhdl_code += f" or current_state = q{final_state}"
    vhdl_code += """ then\n            state_out <= "10111111"; --success -- MSB 1 means final -- only first 2 bits matter
			else
				state_out <= "11111111"; --failure
			end if;
		else
			state_out(7 DOWNTO 6) <= "00";
			
        case current_state is"""
    for state in dfa['states']:
        state_bin = format(int(state['id']), '06b')  # 6-bit representation of state
        vhdl_code += f"            when {state['name']} => state_out(5 DOWNTO 0) <= \"{state_bin}\";\n"

    vhdl_code += """
        end case;
    end if;
    end process;

end Behavioral;
"""

    return vhdl_code


# Main function to parse XML, generate VHDL, and save to a file
def main():
    # Path to your DFA XML file
    dfa_file = "dfa3.xml"

    # Parse DFA from XML
    dfa = parse_dfa(dfa_file)

    # Generate VHDL code
    vhdl_code = generate_vhdl(dfa)

    # Save to a .vhdl file
    with open('dfa_fsm.vhdl', 'w') as f:
        f.write(vhdl_code)
    print("VHDL code generated successfully!")


if __name__ == "__main__":
    main()
