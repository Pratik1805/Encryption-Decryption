#!/bin/bash

function progressbar() {
    local sp='|/-\\'
    local delay=0.1
    local i=0

    echo -n  "${1}..."

    for ((j=0; j<10; j++)); do
        printf "\b${sp:i++%${#sp}:1}"
        sleep $delay
    done
    echo ""
}


function encrypt_file(){
	file_to_encrypt="$1"

	if [ ! -f "${file_to_encrypt}"  ]
	then
		echo "File not found"
		return 1
	fi
	
	gpg -c "$file_to_encrypt"
	
	if [ $? -eq 0  ]
	then
		echo "Encrypted: ${file_to_encrypt}.gpg"
	else
		echo "Encryption Failed!"
	fi
}

function decrypt_file(){
	file_to_decrypt="$1"

	if [ ! -f "${file_to_decrypt}" ]
	then
		echo "File not found"
		return 1
	fi

	gpg "${file_to_decrypt}"

	if [ $? -eq 0  ]
	then
		echo "Decrypted: ${file_to_decrypt} Successfully"
	else
		echo "Decryption Failed!"
	fi
}


echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Ready to Perform Encryption / Decryption  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"

echo "Simply Just enter a file name or a a path to that file and rest easy" 
read file

progressbar "Analyzing"

echo "Select below options to proceed:"


echo "Choose 1 to Encrypt a file"
echo ""
echo "Choose 2 to Decrypt a file"

read -p "So what will you choose[1/2/3]: " choice

case "${choice}" in

	1) progressbar "Encrypting"
	   encrypt_file "${file}"
	   ;;  
	2) progressbar "Decrypting" 
	   decrypt_file "${file}"
	   ;;
	*) echo "Invalid choice" ;;
esac


echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Thanks ! <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"




