output "instance_ip_addr" {
   value = "${aws_instance.tst-box-auto-simp.private_ip}"
}
