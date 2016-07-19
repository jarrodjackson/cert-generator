resource "tls_private_key" "testCAKey" {
		algorithm = "RSA"
		rsa_bits = "2048"
}

resource "tls_private_key" "testDomainKey" {
		algorithm = "RSA"
		rsa_bits = "2048"
}

resource "tls_self_signed_cert" "testCACert" {
	subject {
		common_name = "test-CA-cert.com"
		organization = "Example, Inc"
		organizational_unit = "Department of Terraform Testing"
		street_address = ["5879 Cotton Link"]
		locality = "Pirate Harbor"
		province = "CA"
		country = "US"
		postal_code = "95559-1227"
		serial_number = "2"
	}
	# about 68 years
	validity_period_hours = 87600
	allowed_uses = [
		"cert_signing",
		"server_auth",
		"any_extended",
	]
	key_algorithm = "${tls_private_key.testCAKey.algorithm}"
	private_key_pem = "${tls_private_key.testCAKey.private_key_pem}"
	is_ca_certificate = true
}

resource "tls_cert_request" "testCertRequest" {
		key_algorithm = "${tls_private_key.testDomainKey.algorithm}"
		private_key_pem = "${tls_private_key.testDomainKey.private_key_pem}"

		subject {
			common_name = "${var.commonName}"
			organization = "Example, Inc"
    }
}

resource "tls_locally_signed_cert" "testDomainCert" {
		cert_request_pem = "${tls_cert_request.testCertRequest.cert_request_pem}"
		ca_key_algorithm = "${tls_private_key.testCAKey.algorithm}"
		ca_private_key_pem = "${tls_private_key.testCAKey.private_key_pem}"
		ca_cert_pem = "${tls_self_signed_cert.testCACert.cert_pem}"
		# about 68 years
		validity_period_hours = 87600
		allowed_uses = [
			"server_auth",
			"key_encipherment",
			"digital_signature",
			"non_repudiation",
			"any_extended",
    ]
}
