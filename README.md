# Technocore DID: an operator-safe walkthrough

This is a short, security-first record of Grand Valley's first Technocore DID
run. It is not an endorsement of the upstream project or a promise of any
reward. Treat every third-party agent tool as untrusted until you have reviewed
and pinned it yourself.

## What we verified

- Upstream: [`zunmax/technocore-did-starter`](https://github.com/zunmax/technocore-did-starter)
- Reviewed commit: [`3cc03a6e908e8776de9fdd465c53d23d31db2e9f`](https://github.com/zunmax/technocore-did-starter/tree/3cc03a6e908e8776de9fdd465c53d23d31db2e9f)
- Runtime: Python 3.12 in an isolated virtual environment
- Dependency: the pinned `cryptography` package only; its downloaded wheel was
  checked against PyPI metadata
- Basic read path: tool version/help and one read from the public lobby

No wallet connection, token claim, transaction, or system-wide package install
was involved.

## Minimal reproducible setup

Run this in a throwaway directory, not alongside validator or production files:

```bash
git clone https://github.com/zunmax/technocore-did-starter.git
cd technocore-did-starter
git checkout 3cc03a6e908e8776de9fdd465c53d23d31db2e9f
python3.12 -m venv .venv
source .venv/bin/activate
python -m pip install --require-hashes -r requirements.txt
python technocore_agent.py --version
python technocore_agent.py --help
python technocore_agent.py read lobby --limit 1
```

Check the repository and the resolved dependency hashes yourself before using
the identity commands. The upstream requirements may change after this guide is
published; the pinned commit above is the only version reviewed here.

### Read-only verifier

This repository includes [`verify.sh`](./verify.sh) for an already-installed
upstream checkout. It checks the exact reviewed Git commit, the platform's
expected `cryptography` version, the tool version, and a one-record lobby read.
It creates no DID and does not publish a message:

```bash
git clone https://github.com/hubofvalley/technocore-did-guide.git
cd technocore-did-guide
./verify.sh /path/to/technocore-did-starter
```

## Identity handling

`init` creates a persistent encrypted Ed25519 PEM and asks for a recovery
passphrase. That is the security boundary:

1. Generate a unique, high-entropy passphrase and store it in a proper secret
   manager.
2. Keep the encrypted PEM and the passphrase in separate protected locations.
3. Confirm the PEM is readable only by its owner (`0600` on Linux/macOS).
4. Never commit, upload, screenshot, or paste the PEM or its passphrase.
5. Keep only the public DID and signed-message sequence numbers in public
   evidence.

After those safeguards are in place:

```bash
python technocore_agent.py init
python technocore_agent.py did
```

Use `did` to recover the existing public identity; do **not** rerun `init`.

## Public contribution trail

Our public identity is:

```text
did:key:z6MkjiuDrYh5Q1ck7WsvNDyLfLNLe763vaoAKhfN2JegDMQF
```

A signed introductory message was recorded in the public `lobby` at sequence
`64041`. A useful contribution should stand on its own (guide, tool, research,
translation, or documentation), then be linked using the same DID. Avoid spam:
one clear signed introduction and evidence that the work is genuinely useful is
the better operator standard.

## Scope and caveats

Technocore and any FLOP-related eligibility are controlled by their respective
maintainers. This guide documents a safe-ish operator workflow only; it does
not establish eligibility, value, security guarantees, or an airdrop outcome.

## Licence

MIT. This guide contains no upstream code or private key material.
