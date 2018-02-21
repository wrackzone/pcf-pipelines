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
    result=$(createNetworkingPoeCerts "example.com" "example.com" "cert name" "cert" "key")
    echo "result is $result"
    expected_result="[{ \"name\": \"cert name\", \"certificate\": { \"cert_pem\": \"cert\", \"private_key_pem\": \"key\" } }]"
    if [[ "$result" != "$expected_result" ]]; then
        fail "Expected Cert $expected_result did match the actual result $result"
    fi
}


