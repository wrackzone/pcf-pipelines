#!./test/libs/bats/bin/bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'
load 'helpers/mocks/stub'

generate_cert() {
    echo "{\"certificate\": \"-----BEGIN CERTIFICATE-----\nMIIDTzCCAjegAw...\n-----END CERTIFICATE-----\n\", \"key\": \"-----BEGIN RSA PRIVATE KEY-----\nqD0IQKNpyp0m6w==...\n-----END RSA PRIVATE KEY-----\n\"}"
}

setup() {
  source "$BATS_TEST_DIRNAME/../tasks/config-ert/create-network-poe-certs.sh"
}

teardown() {
  unset POE_SSL_NAME1
  unset POE_SSL_CERT1
  unset POE_SSL_KEY1
  unset POE_SSL_NAME2
  unset POE_SSL_CERT2
  unset POE_SSL_KEY2
  unset POE_SSL_NAME3
  unset POE_SSL_CERT3
  unset POE_SSL_KEY3
}

@test "should generate a cert if name not provided as a parameter or env var" {
    run createNetworkingPoeCerts "example.com" "example.com"
    expected_result="[ { \"name\": \"Certificate 1\", \"certificate\": { \"cert_pem\": \"-----BEGIN CERTIFICATE-----\nMIIDTzCCAjegAw...\n-----END CERTIFICATE-----\n\", \"private_key_pem\": \"-----BEGIN RSA PRIVATE KEY-----\nqD0IQKNpyp0m6w==...\n-----END RSA PRIVATE KEY-----\n\" } } ]"
    assert_equal "${output}" "${expected_result}"
}

@test "should generate a cert if name parameter is 'null'" {
    run createNetworkingPoeCerts "example.com" "example.com" "null"
    expected_result="[ { \"name\": \"Certificate 1\", \"certificate\": { \"cert_pem\": \"-----BEGIN CERTIFICATE-----\nMIIDTzCCAjegAw...\n-----END CERTIFICATE-----\n\", \"private_key_pem\": \"-----BEGIN RSA PRIVATE KEY-----\nqD0IQKNpyp0m6w==...\n-----END RSA PRIVATE KEY-----\n\" } } ]"
    assert_equal "${output}" "${expected_result}"
}

@test "should return one cert if only one is provided as a parameter" {
    expected_result="[{ \"name\": \"some-cert-name\", \"certificate\": { \"cert_pem\": \"some-cert\", \"private_key_pem\": \"some-key\" } }]"
    run createNetworkingPoeCerts "example.com" "example.com" "some-cert-name" "some-cert" "some-key"
    assert_output "${expected_result}"
}

@test "should return one cert if only one is provided as a env var" {
    export POE_SSL_NAME1="some-cert-name"
    export POE_SSL_CERT1="some-cert"
    export POE_SSL_KEY1="some-key"
    expected_result="[{ \"name\": \"some-cert-name\", \"certificate\": { \"cert_pem\": \"some-cert\", \"private_key_pem\": \"some-key\" } }]"
    run createNetworkingPoeCerts "example.com" "example.com"
    assert_output "${expected_result}"
}

@test "should return two certs if two are provided as a parameter" {
    expected_result="[{ \"name\": \"cert 1 name\", \"certificate\": { \"cert_pem\": \"cert 1 pem\", \"private_key_pem\": \"cert 1 private key\" } },{ \"name\": \"cert 2 name\", \"certificate\": { \"cert_pem\": \"cert 2 pem\", \"private_key_pem\": \"cert 2 private key\" } }]"
    run createNetworkingPoeCerts "example.com" "example.com" "cert 1 name" "cert 1 pem" "cert 1 private key" "cert 2 name" "cert 2 pem" "cert 2 private key"
    assert_output "${expected_result}"
}

@test "should return two certs if two are provided as env vars" {
    export POE_SSL_NAME1="cert 1 name"
    export POE_SSL_CERT1="cert 1 pem"
    export POE_SSL_KEY1="cert 1 private key"
    export POE_SSL_NAME2="cert 2 name"
    export POE_SSL_CERT2="cert 2 pem"
    export POE_SSL_KEY2="cert 2 private key"
    expected_result="[{ \"name\": \"cert 1 name\", \"certificate\": { \"cert_pem\": \"cert 1 pem\", \"private_key_pem\": \"cert 1 private key\" } },{ \"name\": \"cert 2 name\", \"certificate\": { \"cert_pem\": \"cert 2 pem\", \"private_key_pem\": \"cert 2 private key\" } }]"
    run createNetworkingPoeCerts "example.com" "example.com"
    assert_output "${expected_result}"
}

@test "should return three certs if three are provided as a parameter" {
    expected_result="[{ \"name\": \"cert 1 name\", \"certificate\": { \"cert_pem\": \"cert 1 pem\", \"private_key_pem\": \"cert 1 private key\" } },{ \"name\": \"cert 2 name\", \"certificate\": { \"cert_pem\": \"cert 2 pem\", \"private_key_pem\": \"cert 2 private key\" } },{ \"name\": \"cert 3 name\", \"certificate\": { \"cert_pem\": \"cert 3 pem\", \"private_key_pem\": \"cert 3 private key\" } }]"
    run createNetworkingPoeCerts "example.com" "example.com" "cert 1 name" "cert 1 pem" "cert 1 private key" "cert 2 name" "cert 2 pem" "cert 2 private key" "cert 3 name" "cert 3 pem" "cert 3 private key"
    assert_output "${expected_result}"
}

@test "should return three certs if three are provided as env vars" {
    export POE_SSL_NAME1="cert 1 name"
    export POE_SSL_CERT1="cert 1 pem"
    export POE_SSL_KEY1="cert 1 private key"
    export POE_SSL_NAME2="cert 2 name"
    export POE_SSL_CERT2="cert 2 pem"
    export POE_SSL_KEY2="cert 2 private key"
    export POE_SSL_NAME3="cert 3 name"
    export POE_SSL_CERT3="cert 3 pem"
    export POE_SSL_KEY3="cert 3 private key"
    expected_result="[{ \"name\": \"cert 1 name\", \"certificate\": { \"cert_pem\": \"cert 1 pem\", \"private_key_pem\": \"cert 1 private key\" } },{ \"name\": \"cert 2 name\", \"certificate\": { \"cert_pem\": \"cert 2 pem\", \"private_key_pem\": \"cert 2 private key\" } },{ \"name\": \"cert 3 name\", \"certificate\": { \"cert_pem\": \"cert 3 pem\", \"private_key_pem\": \"cert 3 private key\" } }]"
    run createNetworkingPoeCerts "example.com" "example.com"
    assert_output "${expected_result}"
}