#!/usr/bin/env bats

setup() {
    load "${BATS_LIB_PATH}/bats-support/load.bash"
    load "${BATS_LIB_PATH}/bats-assert/load.bash"

    TMP="$BATS_TEST_TMPDIR"
}

@test "no args exits 0" {
    run lefthook-git-conflict-markers
    assert_success
}

@test "non-existent file is skipped" {
    run lefthook-git-conflict-markers /nonexistent/file.txt
    assert_success
}

@test "clean file passes" {
    printf 'no conflicts here\n' > "$TMP/clean.txt"
    run lefthook-git-conflict-markers "$TMP/clean.txt"
    assert_success
}

@test "file with <<<<<<< marker fails" {
    cat > "$TMP/conflict.txt" <<'EOF'
some code
<<<<<<< HEAD
my change
=======
their change
>>>>>>> branch
more code
EOF
    run lefthook-git-conflict-markers "$TMP/conflict.txt"
    assert_failure
}

@test "file with only ======= marker fails" {
    printf 'before\n=======\nafter\n' > "$TMP/partial.txt"
    run lefthook-git-conflict-markers "$TMP/partial.txt"
    assert_failure
}

@test "multiple files: one with markers causes failure" {
    printf 'clean\n' > "$TMP/good.txt"
    printf '<<<<<<< HEAD\nconflict\n=======\nother\n>>>>>>> main\n' > "$TMP/bad.txt"
    run lefthook-git-conflict-markers "$TMP/good.txt" "$TMP/bad.txt"
    assert_failure
}

@test "empty file passes" {
    printf '' > "$TMP/empty.txt"
    run lefthook-git-conflict-markers "$TMP/empty.txt"
    assert_success
}
