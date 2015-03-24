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
a/home/centos/rpmbuild/SPECSs the `prefix` (see the Config section above).

# RPM Spec

A rudimentary RPM spec is provided.  It has `rubygem-aws-sdk` as a package
dependency; however, that package isn't officially distributed. I suggest you
either roll that package (and its dependencies) yourself using
[FPM](https://github.com/jordansissel/fpm) or remove the dependency entirely -
your call.

If you choose to FPM, this will help:
```bash
fpm -e -s gem -t rpm --prefix /usr/share/gems multi_xml
fpm -e -s gem -t rpm --prefix /usr/share/gems aws-sdk
fpm -e -s gem -t rpm --prefix /usr/share/gems aws-sdk-resources
fpm -e -s gem -t rpm --prefix /usr/share/gems --gem-bin-path /usr/local/bin aws-sdk-core
rpm --addsign rubygem*.rpm      # YOLO
```
