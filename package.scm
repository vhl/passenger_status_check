;;; Commentary:
;;
;; Development environment for GNU Guix.
;;
;; To install the development snapshot to your profile, run:
;;
;;     guix package -f package.scm
;;
;;; Code:

(use-modules (guix packages)
             (guix licenses)
             (guix build-system ruby)
             (guix git-download)
             (gnu packages)
             (gnu packages version-control)
             (gnu packages ruby))

(package
  (name "passenger-status-check")
  (version "0.1.3")
  (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "https://github.com/vhl/passenger_status_check.git")
                  (commit "a4ebe4e")))
            ;; The hash below is obtained by running the following:
            ;;   git clone https://github.com/vhl/passenger_status_check.git
            ;;   cd passenger_status_check
            ;;   git checkout <commit>
            ;;   rm -rf .git
            ;;   guix hash -r .
            (sha256
             (base32
              "0x81fsv0lif77ppa3nlprsvvkv64gvcayb0ni70a1bi560cb44bf"))))
  (build-system ruby-build-system)
  (arguments
   '(#:phases
     (modify-phases %standard-phases
       (add-after 'unpack 'gitify
         (lambda _
           ;; The gemspec uses 'git ls-files', but the build directory
           ;; has had its '.git' directory removed in order to have
           ;; deterministic checkouts.
           (and (zero? (system* "git" "init"))
                (zero? (system* "git" "add" "."))))))
     #:test-target "spec"))
  (native-inputs
   `(("git" ,git)
     ("bundler" ,bundler)
     ("ruby-rspec" ,ruby-rspec)
     ("ruby-byebug" ,ruby-byebug)))
  (propagated-inputs
   `(("ruby-ox" ,ruby-ox)))
  (synopsis "Parse passenger-status output for instrumentation")
  (description "Passenger_status_check provides a basic command-line
tool to parse the output of the passenger-status utility when
generated as XML.")
  (home-page "https://github.com/vhl/passenger_status_check")
  (license gpl3+))
