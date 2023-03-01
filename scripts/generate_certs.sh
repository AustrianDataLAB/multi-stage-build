#!/usr/bin/env bash

# generate_certs.sh: create a set of self-signed certificates for our webserver

function enter_openssl_dir () {
    # make on openssl directory if none exists 
    mkdir -p openssl && cd openssl
}

function return_to_parent_dir () {
    cd ..
}

function check_for_openssl () {
    # check for openssl command first 
    if ! command -v openssl &> /dev/null; 
    then
        echo "Error: no openssl installed"
        return -1
    fi
}


function create_cert_authority () {
    openssl req -x509 \
                -sha256 -days 356 \
                -nodes \
                -newkey rsa:2048 \
                -subj "/CN=localhost/C=AT/L=Vienna " \
                -keyout rootCA.key -out rootCA.crt 
}

function create_server_private_key () {
    openssl genrsa -out server.key 2048
}

function create_self_sign_config () {
    cat > csr.conf <<EOF
[ req ]
default_bits = 2048
prompt = no
default_md = sha256
req_extensions = req_ext
distinguished_name = dn

[ dn ]
C = AT
ST = Vienna
L = Vienna
O = MLopsHub
OU = MlopsHub Dev
CN = localhost

[ req_ext ]
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = localhost
IP.1 = 127.0.0.1

EOF
}

function create_csr () {
    # create a certificate signing request 
    openssl req -new -key server.key -out server.csr -config csr.conf
}

function create_external_file () {
cat > cert.conf <<EOF

authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = localhost

EOF
}

function gen_ssl () {
    # generate SSL cert 
    openssl x509 -req \
        -in server.csr \
        -CA rootCA.crt -CAkey rootCA.key \
        -CAcreateserial -out server.crt \
        -days 365 \
        -sha256 -extfile cert.conf
}

check_for_openssl
if [ "$?" == -1 ];then
    echo "Error: could not find openssl."
    exit -1
fi

enter_openssl_dir
create_cert_authority
create_server_private_key
create_self_sign_config
create_csr
create_external_file
gen_ssl
return_to_parent_dir
