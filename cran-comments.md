## Resubmission

This is a re-submission of a new release addressing the following CRAN comments:

> Please write references in the description of the DESCRIPTION file in
the form
authors (year) <doi:...> ...

Reference formatting is corrected.

> It seems like you have too many spaces in your description field.
Probably because linebreaks count as spaces too.
Please remove unecassary ones.

Removed spaces before linebreaks.

> \dontrun{} should only be used if the example really cannot be executed...
If I understand correctly those examples are wrapped because they need
'dplyr' to be installed. In this case please list 'dplyr' in ‘Suggests’,
and wrap the examples in if(requireNamespace("pkgname")){} and remove
the \dontrun{}.

Removed examples wrapped in \dontrun{} to avoid adding suggests or depends.
One set of examples is wrapped in \donttest{} because they run 5-10s on some platforms.
  

## Test environments

* GitHub Actions (macOS), release
* GitHub Actions (windows), release
* GitHub Actions (ubuntu-20.04), release, devel
* R-hub (windows), devel
* R-hub (fedora-clang-devel), devel
* R-hub (ubuntu-20.04), devel
* win-builder (windows), devel

## R CMD check results

0 errors | 0 warnings | 1 note


