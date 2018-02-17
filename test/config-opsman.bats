#!./test/libs/bats/bin/bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'
load 'helpers/mocks/stub'

setup() {
  source "$BATS_TEST_DIRNAME/../tasks/config-opsman/configure-auth.sh"
}

@test "should configure auth of opsman" {
    om_domain_or_ip_address="0.0.0.0"
    om_user="user"
    om_password="password"
    om_decryption_pwd="decryptpassword"

    curl_opts="--output /dev/null -k --silent --head --fail https://${om_domain_or_ip_address}/setup : echo"
    om_args="--target https://${om_domain_or_ip_address} --skip-ssl-validation configure-authentication --username ${om_user} --password ${om_password} --decryption-passphrase ${om_decryption_pwd} : echo 'configuration complete'"

    stub curl "${curl_opts}"
    stub om-linux "${om_args}"

    run configure_authentication "${om_domain_or_ip_address}" "${om_user}" "${om_password}" "${om_decryption_pwd}"
    [ "$status" = 0 ]
    [ "$?" -eq 0 ]

    assert_success
    assert_output "configuration complete"

    unstub curl
    unstub om-linux
}
