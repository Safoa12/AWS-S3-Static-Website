
#My s3 bucket
resource "aws_s3_bucket" "mybucket" {
  bucket = var.bu

}

#My s3 bucket ownership policy
resource "aws_s3_bucket_ownership_controls" "object_ownership" {
  bucket = aws_s3_bucket.mybucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}


#My s3 bucket public access block
resource "aws_s3_bucket_public_access_block" "public-a" {
  bucket = aws_s3_bucket.mybucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

#S3 bucket acl
resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_ownership_controls.object_ownership,
    aws_s3_bucket_public_access_block.public-a,
  ]
  bucket = aws_s3_bucket.mybucket.id
  acl    = "public-read"
}


#Aws s3 object index
resource "aws_s3_object" "index" {
    bucket = aws_s3_bucket.mybucket.id
    key = "index.html"
    source = "index.html"
    acl = "public-read"
    content_type = "text/html" 
}

#S3 Object error
resource "aws_s3_object" "error" {
    bucket = aws_s3_bucket.mybucket.id
    key = "error.html"
    source = "error.html"
    acl = "public-read"
    content_type = "text/html"
}

#S3 Object for my image
resource "aws_s3_object" "s3obj" {
    bucket = aws_s3_bucket.mybucket.id
    key = "profile.png"
    source = "profile.png"
    acl = "public-read"
}


resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.mybucket.id
  index_document {
    suffix = "index.html"
  }
  
error_document {
    key = "error.html"
  }
depends_on = [ aws_s3_bucket_acl.example ]
}