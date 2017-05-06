resource "aws_s3_bucket_object" "object" {
  bucket = "${var.aws_account}"
  key    = "dummy_object"
  source = "outputs.tf"
  etag   = "${md5(file("outputs.tf"))}"
}
