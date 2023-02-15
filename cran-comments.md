## Test environments

* GitHub Actions (macOS), release
* GitHub Actions (windows), release
* GitHub Actions (ubuntu-20.04), release, devel
* R-hub (windows), devel
* R-hub (fedora-clang-devel), devel
* R-hub (ubuntu-20.04), devel
* win-builder (windows), devel

## R CMD check results

0 errors | 0 warnings | 2 notes

* This is a new release.

* long running examples (10s) in `fa()` are 
  wrapped with `\donttest{}`.
  
## Other comments

* Portions of some examples that demonstrate
  how to use functions within "tidy" 
  workflows are wrapped in `\dontun{}`
  to avoid `dplyr` dependency.
