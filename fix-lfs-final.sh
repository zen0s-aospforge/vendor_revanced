#!/bin/bash

# Fix Git LFS configuration for already-pushed large files

set -e

echo "================================"
echo "Fixing Git LFS for ReVanced Repo"
echo "================================"
echo ""

# Check if git lfs is installed
if ! command -v git-lfs &> /dev/null; then
    echo "Error: Git LFS is not installed!"
    echo "Please install it from https://git-lfs.github.com"
    exit 1
fi

echo "[1/5] Initializing Git LFS..."
git lfs install --force

echo "[2/5] Tracking APK files with LFS..."
git lfs track "*.apk"
git add .gitattributes

echo "[3/5] Resetting git history to remove large files..."
# Get the last commit hash before the large files were added
# We'll do a soft reset to allow re-adding files properly
git reset HEAD~2

echo "[4/5] Clearing git cache for APK files..."
git rm --cached common/product/app/YouTube/com.google.android.youtube.apk 2>/dev/null || true
git rm --cached common/product/app/YTMusic/com.google.android.apps.youtube.music.apk 2>/dev/null || true
git rm --cached common/product/etc/rv/YTPatched.apk 2>/dev/null || true
git rm --cached common/product/etc/rv/YTMusicPatched.apk 2>/dev/null || true

echo "[5/5] Re-adding files with LFS tracking..."
git add .gitattributes
git add common/product/app/YouTube/com.google.android.youtube.apk
git add common/product/app/YTMusic/com.google.android.apps.youtube.music.apk
git add common/product/etc/rv/YTPatched.apk
git add common/product/etc/rv/YTMusicPatched.apk
git add common/Android.mk common/BoardConfigVendor.mk common/common-vendor.mk products/ sepolicy/

echo ""
echo "✅ Files ready to commit!"
echo ""
echo "Next steps:"
echo "1. Review the changes: git status"
echo "2. Commit: git commit -m 'Add real APKs with Git LFS'"
echo "3. Force push: git push -f origin qpr2-new"
echo ""
