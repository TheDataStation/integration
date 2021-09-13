# The Data Station integration repository

The Data Station components are spread across a number of
GitHub repositories.

This integration repository is intended to contain
infrastructure to compose multiple repositories into useful
things.

At present, it is focused around integration testing using GitHub Actions.

There are two integration tests, structured in the same way. One tests
the descendants of the slowly-being-separated aurum-dod-staging repository.
The other tests the user register components.

Futher components which need testing should either be added as similarly
structured tests (if standalone from the existing components) or added
into one of the existing tests.

## Integration Testing Using Github Actions

In the context of this repository, there are two distinct kinds of
testing:

- Repository-local testing (that is, tests which do not need any other
repository) should be implemented using Github Actions in the
respective repositories.

- Integration testing (that is, tests which need to combine several
Data Station repositories) should be implemented using Github Actions in
this repository.

## How

- An integration test is defined as a GitHub Action in this repository
in the .github/actions/ directory.

- Each integration test checks out all of the repositories that it needs,
  and then does whatever it needs to run the test. This may include
  checking out this integration repository to get (for example)
  docker-compose definitions or test scripts.

- Each integration test should be invoked inside each relevant repository,
  as part of that repositories GitHub Actions CI workflow, alongside any
  repository-local tests.

  This means that each pull request to a component repository is tested by
  the full integration test suite.

  The integration test action should allow each component repository to be 
  overridden, and the action invocation in each repository should override
  the default for itself to point to the current PR/reference being tested
  (rather than defaulting to `main` or `master`).

  This means that the integration test runs against the current `main`
  version of everything except the change that the current PR is proposing.

