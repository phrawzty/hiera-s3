# Yet Another S3 Backend for Hiera

This is a simple S3 backend for Hiera. It makes use of `aws-sdk` **version 2**.
It also makes the assumption that you're using **IAM Roles** for auth.

# Config

```yaml
:backends:
    - S3

:s3:
    :bucket: 'your_bucket'  # required
    :region: 'region'       # required; see below
    :prefix: 'directory/'   # optional
```

If `region` isn't specified, this plugin will check Facter for
`ec2_placement_availability_zone` and massage it as necessary; however, if that
fails, then all is lost!

# Examples

The basic idea is to treat S3 like nestable key-value store: each file in the
bucket is a key and the contents of that file are the value. You can put the
files in a directory of that bucket - just specify the name of that directory
as the `prefix` (see the Config section above).
