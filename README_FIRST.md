# Ruby Dockerfile forked for jemalloc

This is a fork of Docker's builds for Ruby designed to take the latest from Docker and then inject the jemalloc build instruction into the Ruby compile step. This allows us to enjoy all the Ruby build options designed for Docker but with jemalloc replacing regular malloc.

You will need to ensure your Git repo has a upstream of the original fork:

`.git/config`:
```
[remote "upstream"]
  url = git@github.com:docker-library/ruby.git
  fetch = +refs/heads/*:refs/remotes/upstream/*
```

## Syncing

* Fetch the latest from this upstream: `git fetch upstream master`
* Merge in the latest changes: `git merge upstream/master`
* Run `inject_jemalloc.rb` to inject the build instructions (this patches each `Dockerfile` include the jemalloc options)
  * You should see this working by running `git diff` and seeing the injected changes
* Run `build.rb` to build each image
