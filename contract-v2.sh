#! /bin/bash

ocean="NaiHai"
mng_method="Co-opt"

init() {
	cat << EOF

    This contract is made to agree that the South China Sea ownership style is co-opterativ.

    *** Please confirm the following items ***
EOF
}

confirm_vol_price() {
	cat << EOF

    ---------------------------------------------------------------------------
    <The volume & price>

    * 1.61 TWD / mL
    * Include: The South China Sea international waters area
    ---------------------------------------------------------------------------
EOF
	read -p "AGREE (yes/no)? " ans
	if [ "`echo "$ans" | tr '[:upper:]' '[:lower:]'`" != "yes" ]; then
		echo "exit."
		exit
	fi
}

confirm_mng_method() {
	cat << EOF

    ---------------------------------------------------------------------------
    <Management method>

    * Participate the $mng_method as a legal person: adopt the Equator Principles
    * Participate the $mng_method as a natural person: adopt the relating ecological 
      and economical responsibility of the South China Sea
    ---------------------------------------------------------------------------
EOF
	read -p "AGREE (yes/no)? " ans
	if [ "`echo "$ans" | tr '[:upper:]' '[:lower:]'`" != "yes" ]; then
		echo "exit."
		exit
	fi
}

confirm_profits() {
	cat << EOF

    ---------------------------------------------------------------------------
    <Relating Profits>

    Each member-owner of the South China Sea Co-opterative Preparation 
    Committee has the same weight of vote to manage it.
    ---------------------------------------------------------------------------
EOF
	read -p "AGREE (yes/no)? " ans
	if [ "`echo "$ans" | tr '[:upper:]' '[:lower:]'`" != "yes" ]; then
		echo "exit."
		exit
	fi
}

generate_contract() {

	read -p "WHO? " name
	clear
	cat <<EOF > contract.txt

This contract is made to agree that the South China Sea ownership style is 
co-opterativ

BETWEEN:
South China Sea Co-opterative Preparation Committee
AND
Forkonomy() Project Participants

In consideration of the South China Sea ownership and other valuable 
considerations, the Parties agree as follows:

1. The volume & price of the South China Sea contains in this agreement

   * 1.61 TWD / mL
   * Include: The South China Sea international waters area

2. Management method:

   * Participate the Co-opt as a legal person: adopt the Equator Principles
   * Participate the Co-opt as a natural person: adopt the relating ecological 
     and economical responsibility of the South China Sea

3. Relating Profits:
   Each member-owner of the South China Sea Co-opterative Preparation 
   Committee has the same weight of vote to manage it.

Signature of the Participant: $name

This Contract is made on `date`

EOF
}

show_contract() {
	cat contract.txt
}

main() {
	init
	confirm_vol_price
	confirm_mng_method
	confirm_profits
	generate_contract
	show_contract
}

main
