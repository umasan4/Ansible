#------------------------------
# s3
#------------------------------
resource "aws_s3_bucket" "remote_backend" {
  bucket = "bucketname"
}