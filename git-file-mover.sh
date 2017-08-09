#!/bin/bash
function move() {
    local source_repository;
    local source_branch;
    local dest_repository;
    local dest_branch;
    local tomove;
    local tmpdir;
    local tmpsourcedir="${tmpdir}/source"
    local tmpdestdir="${tmpdir}/dest"

    git clone ${source_repository} ${tmpsourcedir}
    cd ${tmpsourcedir}
    git checkout -b ${source_branch} origin/${source_branch}
    git remote rm origin
    git filter-branch --subdirectory-filter ${tomove} -- --all
    git reset --hard
    git gc --aggressive
    git prune
    git add .
    git commit
    git clone ${dest_repository} ${tmpdestdir}
    cd ${tmpdestdir}
    git remote add ${source_branch} ${tmpsourcedir}
    git pull ${source_branch} ${dest_branch} --allow-unrelated-histories
    git remote rm ${source_branch}
    git push
}
