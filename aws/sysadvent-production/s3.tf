resource "aws_s3_bucket_object" "object" {
  bucket = "${basename (path.cwd)}"
  key    = "dummy_object"
  source = "outputs.tf"
  etag   = "${md5(file("outputs.tf"))}"
}
