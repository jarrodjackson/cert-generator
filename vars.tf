variable "commonName" {}

output "certificate_body" {
	value = "${tls_locally_signed_cert.testDomainCert.cert_pem}"
}

output "certificate_chain" {
	value = "${format("%s",
		tls_self_signed_cert.testCACert.cert_pem
	)}"
}

output "certificate_private_key" {
	value = "${tls_private_key.testDomainKey.private_key_pem}"
}
