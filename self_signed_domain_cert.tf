resource "tls_private_key" "testCAKey" {
		algorithm = "ECDSA"
		ecdsa_curve = "P384"
}

resource "tls_self_signed_cert" "testCACert" {
	subject {
		common_name = "example.com"
		organization = "Example, Inc"
		organizational_unit = "Department of Terraform Testing"
		street_address = ["5879 Cotton Link"]
		locality = "Pirate Harbor"
		province = "CA"
		country = "US"
		postal_code = "95559-1227"
		serial_number = "2"
	}
	allowed_uses = [
		"cert_signing",
	]
	key_algorithm = "ECDSA"
	private_key_pem = "${tls_private_key.testCAKey.private_key_pem}"
	is_ca_certificate = true
}

resource "tls_cert_request" "testCertRequest" {
		key_algorithm = "ECDSA"
		private_key_pem = "${tls_private_key.testCAKey.private_key_pem}"

    subject {
        common_name = "example.com"
        organization = "Example, Inc"
    }
}

resource "tls_locally_signed_cert" "testDomainCert" {
    cert_request_pem = "${tls_cert_request.testCertRequest.cert_request_pem}"
		ca_key_algorithm = "ECDSA"
		ca_private_key_pem = "${tls_private_key.testCAKey.private_key_pem}"
		ca_cert_pem = "${tls_self_signed_cert.testCACert.cert_pem}"

		allowed_uses = [
			"server_auth",
    ]
}
