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
    m_start="<""<<""<<""<<"
    m_sep="=""===""==="
    m_end=">"">>"">>"">"
    printf 'some code\n%s HEAD\nmy change\n%s\ntheir change\n%s branch\nmore code\n' \
        "$m_start" "$m_sep" "$m_end" > "$TMP/conflict.txt"
    run lefthook-git-conflict-markers "$TMP/conflict.txt"
    assert_failure
}

@test "file with only ======= marker fails" {
    m_sep="=""===""==="
    printf 'before\n%s\nafter\n' "$m_sep" > "$TMP/partial.txt"
    run lefthook-git-conflict-markers "$TMP/partial.txt"
    assert_failure
}

@test "multiple files: one with markers causes failure" {
    m_start="<""<<""<<""<<"
    m_sep="=""===""==="
    m_end=">"">>"">>"">"
    printf 'clean\n' > "$TMP/good.txt"
    printf '%s HEAD\nconflict\n%s\nother\n%s main\n' \
        "$m_start" "$m_sep" "$m_end" > "$TMP/bad.txt"
    run lefthook-git-conflict-markers "$TMP/good.txt" "$TMP/bad.txt"
    assert_failure
}

@test "empty file passes" {
    printf '' > "$TMP/empty.txt"
    run lefthook-git-conflict-markers "$TMP/empty.txt"
    assert_success
}
