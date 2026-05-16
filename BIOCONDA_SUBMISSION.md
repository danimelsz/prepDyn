# Steps to Submit prepDyn to Bioconda

## Step 1: Create a GitHub Release (if not already done)

You need to tag your current code as a release version. This allows Bioconda to fetch the source.

The current repository HEAD is tagged as `v0.5.0`. If you need to recreate or move forward with a new release, update the version in `setup.py` first and then tag it.

Create the release on GitHub:
- Go to https://github.com/danimelsz/PrepDyn/releases
- Click "Draft a new release"
- Set tag to `v0.5.0`
- Add release title and description
- Publish the release

## Step 2: Compute SHA256 Hash

Once the release is created, compute the SHA256 hash of the source archive:

```bash
# Download the archive
curl -L https://github.com/danimelsz/PrepDyn/archive/refs/tags/v0.5.0.tar.gz -o prepdyn-0.5.0.tar.gz

# Compute SHA256
sha256sum prepdyn-0.5.0.tar.gz
# or on macOS
shasum -a 256 prepdyn-0.5.0.tar.gz
```

Copy the hash value if you want to switch the recipe from `git_url`/`git_rev` to a release tarball URL.

## Step 3: Update meta.yaml with SHA256

If you prefer a tarball-based recipe instead of the included `git_url`/`git_rev` recipe, replace the source block with:

```yaml
source:
  url: https://github.com/danimelsz/PrepDyn/archive/refs/tags/v{{ version }}.tar.gz
  sha256: <YOUR_SHA256_HASH_HERE>
```

## Step 4: Fork bioconda-recipes

1. Go to https://github.com/bioconda/bioconda-recipes
2. Click the "Fork" button
3. Clone your fork locally:
   ```bash
   git clone https://github.com/dnakamuraz/bioconda-recipes.git
   cd bioconda-recipes
   ```

## Step 5: Create the Recipe Directory

```bash
# Create the recipe directory
mkdir -p recipes/prepdyn

# Copy the meta.yaml file
cp ../B3_PrepDyn/GitHub/recipes/prepdyn/meta.yaml recipes/prepdyn/meta.yaml
```

## Step 6: Test the Recipe Locally (Optional but Recommended)

```bash
# If you have conda-build installed
conda build recipes/prepdyn/

# Or using bioconda's test environment
conda create -n bioconda-test -c conda-forge python=3.10 conda-build
conda activate bioconda-test
conda build recipes/prepdyn/
```

## Step 7: Push to Your Fork and Create a Pull Request

```bash
git checkout -b add-prepdyn
git add recipes/prepdyn/
git commit -m "Add prepdyn recipe to bioconda"
git push origin add-prepdyn
```

Then:
1. Go to https://github.com/bioconda/bioconda-recipes
2. Click "New Pull Request"
3. Select your fork and the `add-prepdyn` branch
4. Fill in the PR template with:
   - Description of the package
   - Link to the GitHub repository
   - Any special build/test requirements
5. Submit the PR

## Step 8: Review and Merge

The Bioconda team will review your PR. They may request:
- Changes to the recipe
- License verification
- Additional documentation
- Testing on different platforms

Once approved, your package will be available on the Bioconda channel:

```bash
conda install -c bioconda prepdyn
```

## Notes

- Make sure your package version in setup.py matches the version in meta.yaml
- The `noarch: python` setting is used because this is a pure Python package
- MAFFT is specified from the main conda channel (which includes conda-forge packages)
- All entry points (prepDyn, GB2MSA, addSeq, UP2AP) are tested in the recipe
