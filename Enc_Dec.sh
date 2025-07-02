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

	read -sp "Enter Password for the file: " PASSWORD
	
	# Encrypt the specified file using symmetric encryption with the provided password.
	# --batch: run in non-interactive mode (required when using in scripts).
	# --yes: automatically overwrite output file if it exists.
	# --passphrase: supplies the password non-interactively for encryption.
	# -c: use symmetric encryption (instead of public-key).
	gpg --batch --yes --passphrase "${PASSWORD}" -c "$file_to_encrypt"
	progressbar "Encrypting"

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

	gpg -d "${file_to_decrypt}" > "${file_to_decrypt}.txt"
	progressbar "Decrypting"

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
echo ""
read -p "So what will you choose[1/2]: " choice

case "${choice}" in

	1) encrypt_file "${file}"
	   ;;  
	2) decrypt_file "${file}"
	   ;;
	*) echo "Invalid choice" ;;
esac

gpgconf --kill gpg-agent #FLush gpg cache immediately which stores password for some time
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Thanks ! <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"




