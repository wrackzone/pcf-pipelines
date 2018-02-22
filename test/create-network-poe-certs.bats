#!./test/libs/bats/bin/bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'
load 'helpers/mocks/stub'

setup() {
  source "$BATS_TEST_DIRNAME/../tasks/config-ert/create-network-poe-certs.sh"
}

@test "should generate a cert if name not provided" {
    run createNetworkingPoeCerts "example.com" "example.com"
    assert_success
}

@test "should return one cert if only one is provided" {
    expected_result="[{ \"name\": \"some-cert-name\", \"certificate\": { \"cert_pem\": \"some-cert\", \"private_key_pem\": \"some-key\" } }]"
    run createNetworkingPoeCerts "example.com" "example.com" "some-cert-name" "some-cert" "some-key"
    assert_output "${expected_result}"
}


