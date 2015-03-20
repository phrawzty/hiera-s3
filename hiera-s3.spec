Name:       hiera-s3
Version:    0.0.2
Release:    2%{?dist}
Summary:    S3 backend for Hiera
License:    MPLv2
URL:        https://github.com/phrawzty/hiera-s3
Group:      Development/Tools
Source0:    https://github.com/phrawzty/hiera-s3/archive/%{version}.zip
BuildRoot:  %(mktemp -ud %{_tmppath}/%{name}-%{version}-%{release}-XXXXXX)
BuildArch:  noarch
Requires:   rubygem-aws-sdk

%description
Yet Another S3 Backend for Hiera.

%prep
%setup -q

%install
mkdir -p %{buildroot}/%{_sysconfdir}/puppet/modules/hiera_s3/lib/hiera/backend
cp s3_backend.rb %{buildroot}/%{_sysconfdir}/puppet/modules/hiera_s3/lib/hiera/backend

%clean
rm -rf %{buildroot}

%files
%doc README.md
%defattr(-,root,root,-)
%dir %attr(755, root, root) %{_sysconfdir}/puppet/modules/hiera_s3
%attr(644, root, root) %{_sysconfdir}/puppet/modules/hiera_s3/lib/hiera/backend/s3_backend.rb

%changelog
* Wed Mar 18 2015 Dan Phrawzty <phrawzty@mozilla.com>
- init
