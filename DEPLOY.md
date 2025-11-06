# Deployment Guide

This guide explains how to deploy the Lovely game to GitHub Pages.

## Prerequisites

- Node.js 20+ installed
- Git repository configured
- GitHub repository created

## One-Command Deployment

```bash
npm run deploy
```

This single command will:
1. Build the `.love` file
2. Convert it to a web version using love.js
3. Deploy to GitHub Pages

## Initial Setup

### 1. Install Dependencies

```bash
npm install
```

### 2. Configure GitHub Pages

#### Option A: Using GitHub Actions (Recommended)

The repository includes a GitHub Action that automatically deploys on every push to `main`.

**Setup steps:**
1. Push your code to GitHub
2. Go to your repository Settings → Pages
3. Under "Source", select "GitHub Actions"
4. Push to main branch - deployment happens automatically!

Your game will be available at: `https://yourusername.github.io/lovely/`

#### Option B: Manual Deployment

If you prefer manual control:

1. Run the deploy command:
   ```bash
   npm run deploy
   ```

2. Go to your repository Settings → Pages
3. Under "Source", select "Deploy from a branch"
4. Select the `gh-pages` branch
5. Click Save

## Available Scripts

### `npm run build:love`
Creates the `.love` file in the `build/` directory.

### `npm run build:web`
Converts the `.love` file to a web version using love.js. Output goes to `web/` directory.

### `npm run build`
Runs both `build:love` and `build:web` in sequence.

### `npm run deploy`
Builds everything and deploys to GitHub Pages (gh-pages branch).

### `npm run serve`
Serves the web build locally for testing at http://localhost:3000

## Testing Locally

Before deploying, test the web build locally:

```bash
npm run build
npm run serve
```

Then open http://localhost:3000 in your browser.

## Automatic Deployment with GitHub Actions

The included GitHub Action ([.github/workflows/deploy.yml](.github/workflows/deploy.yml)) automatically:
- Triggers on every push to `main`
- Can be manually triggered from the Actions tab
- Builds the game
- Deploys to GitHub Pages

**Workflow:**
1. Make changes to your game
2. Commit and push to `main`
3. GitHub Actions builds and deploys automatically
4. Your site updates in ~1-2 minutes

## Troubleshooting

### "gh-pages: command not found"
Run `npm install` to install dependencies.

### Build fails in GitHub Actions
- Check that `build.sh` has execute permissions: `git update-index --chmod=+x build.sh`
- Verify Love2D syntax in your Lua files

### Game doesn't load on GitHub Pages
- Check browser console for errors (F12)
- Verify the game works locally first: `npm run serve`
- Check that all assets use relative paths

### Page shows 404
- Verify GitHub Pages is enabled in repository settings
- Wait 1-2 minutes after deployment
- Clear browser cache

## Configuration

### Update Repository URL

Edit [package.json](package.json) and update the repository URL:

```json
"repository": {
  "type": "git",
  "url": "git+https://github.com/yourusername/lovely.git"
}
```

### Adjust Memory Allocation

If your game needs more memory, edit the `build:web` script in package.json:

```json
"build:web": "npx love.js build/lovely.love web --title \"Lovely\" --memory 33554432"
```

Memory values (in bytes):
- 16777216 = 16 MB (default)
- 33554432 = 32 MB
- 67108864 = 64 MB

## File Structure

```
lovely/
├── .github/
│   └── workflows/
│       └── deploy.yml          # GitHub Actions workflow
├── package.json                # Node.js config & scripts
├── build/                      # Native builds (gitignored)
│   └── lovely.love            # Love2D package
├── web/                        # Web build (gitignored, deployed to gh-pages)
│   ├── index.html
│   ├── game.js
│   └── game.data
└── [source files...]
```

## Custom Domain (Optional)

To use a custom domain:

1. Create a `CNAME` file in the `web/` directory:
   ```
   yourdomain.com
   ```

2. Configure DNS at your domain provider:
   - Add a CNAME record pointing to `yourusername.github.io`

3. Enable custom domain in GitHub Pages settings

## Security

The GitHub Action uses:
- `GITHUB_TOKEN` - automatically provided by GitHub
- `contents: read` - to read repository
- `pages: write` - to deploy to Pages
- `id-token: write` - for Pages deployment

No additional secrets needed!

## Performance Tips

1. **Optimize Assets**: Compress images before including them
2. **Reduce Memory**: Use the minimum memory your game needs
3. **Test on Mobile**: The web version works on mobile browsers
4. **Add Loading Screen**: Consider adding a loading indicator for slower connections

## Next Steps

After deploying:
1. Share your game URL!
2. Add the URL to your README
3. Test on different browsers
4. Get feedback and iterate

## Links

- [Love2D Documentation](https://love2d.org/wiki/Main_Page)
- [love.js GitHub](https://github.com/Davidobot/love.js)
- [GitHub Pages Documentation](https://docs.github.com/en/pages)
