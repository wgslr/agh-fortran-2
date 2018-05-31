# Testing

Tests can be run with the `make test` command. The tested module can be changed by providing `MODULE` variable, i.e.
```bash
make test -B MODULE=naive # test basic implementation
make test -B MODULE=dot # test dot_product based implementation
```

To run tests for all modules use
```bash
make testall
```