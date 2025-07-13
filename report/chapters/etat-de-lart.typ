= État de l'art <etatdelart>

== Amélioration des compétences en cybersécurité

```yaml
# CARGO PACKAGES
# Packages built from source
# https://rustup.rs/ -> instead of runnings "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh", we can get rustup via dnf and then run it.
- name: Install Rustup via DNF, and build tools like gcc and cmake for cargo builds
  become: true
  ansible.builtin.dnf:
    name:
      - rustup # the Rust toolings manager, help to have all tools up-to-date, add toolchains, ...
      - gcc # a C compiler is necessary to build some crates
      - cmake
      - openssl-devel # used for cargo-update and typst-cli probably

- name: Run rustup init to install all useful Rust tools
  ansible.builtin.command:
    cmd: rustup-init -y
    creates: "{{ ansible_env.HOME }}/.cargo/bin/rustc"

```

test `test` est un outil de gestion de la sécurité des systèmes d'information, qui permet de suivre les vulnérabilités et les correctifs. Il est utilisé pour améliorer les compétences en cybersécurité.

== Serious games comme solution

== Écosystèmes existants 


