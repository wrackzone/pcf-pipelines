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

@test "should generate a cert if name not provided" {
    run createNetworkingPoeCerts "example.com" "example.com"
    expected_result="[ { \"name\": \"Certificate 1\", \"certificate\": { \"cert_pem\": \"-----BEGIN CERTIFICATE-----\nMIIDTzCCAjegAw...\n-----END CERTIFICATE-----\n\", \"private_key_pem\": \"-----BEGIN RSA PRIVATE KEY-----\nqD0IQKNpyp0m6w==...\n-----END RSA PRIVATE KEY-----\n\" } } ]"
    assert_equal "${output}" "${expected_result}"
}

@test "should generate a cert if name is 'null'" {
    run createNetworkingPoeCerts "example.com" "example.com" "null"
    expected_result="[ { \"name\": \"Certificate 1\", \"certificate\": { \"cert_pem\": \"-----BEGIN CERTIFICATE-----\nMIIDTzCCAjegAw...\n-----END CERTIFICATE-----\n\", \"private_key_pem\": \"-----BEGIN RSA PRIVATE KEY-----\nqD0IQKNpyp0m6w==...\n-----END RSA PRIVATE KEY-----\n\" } } ]"
    assert_equal "${output}" "${expected_result}"
}

@test "should return one cert if only one is provided" {
    expected_result="[{ \"name\": \"some-cert-name\", \"certificate\": { \"cert_pem\": \"some-cert\", \"private_key_pem\": \"some-key\" } }]"
    run createNetworkingPoeCerts "example.com" "example.com" "some-cert-name" "some-cert" "some-key"
    assert_output "${expected_result}"
}

@test "should return two certs if two are provided" {
    expected_result="[{ \"name\": \"cert 1 name\", \"certificate\": { \"cert_pem\": \"cert 1 pem\", \"private_key_pem\": \"cert 1 private key\" } },{ \"name\": \"cert 2 name\", \"certificate\": { \"cert_pem\": \"cert 2 pem\", \"private_key_pem\": \"cert 2 private key\" } }]"
    run createNetworkingPoeCerts "example.com" "example.com" "cert 1 name" "cert 1 pem" "cert 1 private key" "cert 2 name" "cert 2 pem" "cert 2 private key"
    assert_output "${expected_result}"
}

@test "should return three certs if three are provided" {
    expected_result="[{ \"name\": \"cert 1 name\", \"certificate\": { \"cert_pem\": \"cert 1 pem\", \"private_key_pem\": \"cert 1 private key\" } },{ \"name\": \"cert 2 name\", \"certificate\": { \"cert_pem\": \"cert 2 pem\", \"private_key_pem\": \"cert 2 private key\" } },{ \"name\": \"cert 3 name\", \"certificate\": { \"cert_pem\": \"cert 3 pem\", \"private_key_pem\": \"cert 3 private key\" } }]"
    run createNetworkingPoeCerts "example.com" "example.com" "cert 1 name" "cert 1 pem" "cert 1 private key" "cert 2 name" "cert 2 pem" "cert 2 private key" "cert 3 name" "cert 3 pem" "cert 3 private key"
    assert_output "${expected_result}"
}
