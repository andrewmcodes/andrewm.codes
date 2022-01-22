---
series: null
featured: false
title: Creating a blog with Bridgetown and Netlify CMS
description: This is a quick tutorial to showcase how you can quickly integrate Netlify CMS into your Bridgetown s...
urls:
  dev_to: 'https://dev.to/andrewmcodes/creating-a-blog-with-bridgetown-and-netlify-cms-1d1a'
tags:
  - tutorial
  - beginners
  - bridgetown
  - cms
categories: archived
date: '2020-07-11T04:19:55Z'
lastmod: '2022-01-22T02:23:32.779Z'
---

This is a quick tutorial to showcase how you can quickly integrate Netlify CMS into your [Bridgetown](https://www.bridgetownrb.com) site.

The code for this tutorial can be found at:

{% github andrewmcodes/bridgetown-netlify-cms-starter no-readme %}

Let's get started!

### Setup

For detailed instructions on getting Bridgetown set up on your local machine, take a look at the [Bridgetown Getting Started Documentation](https://www.bridgetownrb.com/docs/) and the [Bridgetown Installation Guides](https://www.bridgetownrb.com/docs/installation).

The TL;DR is you need Ruby `>= 2.5`, Bundler, Node `>= 10.13`, Yarn, and the Bridgetown gem installed.

You can install the gem by running the following command in your terminal:

```bash
gem install bridgetown
```

As far as the other dependencies go, you don't have to use the same versions that I am as long as you meet the minimum requirements above, but this is what I am currently using:

- Ruby 2.7.1
  - Bundler 2.4.1
- Node 13.11.0
  - Yarn 1.22.4

### Creating a new Bridgetown site

The first thing we are going to do is generate a new Bridgetown site.

Run the following command in your terminal:

```bash
bridgetown new bridgetown-netlify-cms-starter
cd bridgetown-netlify-cms-starter
```

Our new site has been generated! :tada:

Let's take a look! Run `yarn start` in your terminal and open `http://localhost:4000` in your browser.

![Alt Text](https://dev-to-uploads.s3.amazonaws.com/i/m9dg93scfne9srinnpkw.jpg)

#### Optional Styling

Just to make this a little prettier, I am going to add [new.css](https://newcss.net), which just adds styles to your default HTML. If you'd like to do the same, add the following in your head component at `src/_components/head.liquid`:

```html
<!-- src/_components/head.liquid -->
<link rel="stylesheet" href="https://fonts.xz.style/serve/inter.css" />
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@exampledev/new.css@1.1.2/new.min.css" />
```

And remove the contents of `frontend/styles/index.scss`.

### Adding Netlify CMS to your site

_I won't be going in great depth about the specific features of Netlify CMS, I encourage taking a looking at the [Netlify CMS Documentation](https://www.netlifycms.org/docs/intro/) to learn more._

We are going to create an `admin` folder with two files: `index.html` and `config.yml`:

```bash
mkdir src/admin
touch src/admin/index.html
touch src/admin/config.yml
```

Paste the following inside of `src/admin/index.html`:

```html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8" />
    <meta http-equiv="x-ua-compatible" content="ie=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <title>Netlify CMS</title>
    <script src="https://identity.netlify.com/v1/netlify-identity-widget.js" type="text/javascript"></script>
  </head>
  <body>
    <script src="https://unpkg.com/netlify-cms@^2.0.0/dist/netlify-cms.js" type="text/javascript"></script>
  </body>
</html>
```

And in `src/admin/config.yml`

```yml
backend:
  name: git-gateway # required for using Github
  branch: main # the default branch you want CMS changes merged to
  commit_messages: # Optional: configure the commit messages Netlify CMS will use when publishing changes
    create: "feat({{collection}}): :sparkles: Create {{slug}}"
    update: "chore({{collection}}): :recycle: Update {{slug}}"
    delete: "chore({{collection}}): :recycle: Delete {{slug}}"
    uploadMedia: "feat(assets): :bento: Upload {{path}}"
    deleteMedia: "chore(assets): :wastebasket: Delete {{path}}"

local_backend: true # Enable the CMS locally

media_folder: src/images/uploads # location of where we want images uploaded via the CMS put

collections:
  - name: blog # collection name
    label: Blog # label in the CMS
    folder: src/_posts/ # location of the files that make up the collection
    extension: .md # extension of those files
    format: frontmatter # format to use
    create: true # allow creation of new items in this collection
    slug: "{{year}}-{{month}}-{{day}}-{{title}}" # the slug to use when creating new items
    editor:
      preview: false # According to the documentation, this won't work with our setup, but I didn't try
    fields: # Fields for the collection
      - { label: Layout, name: layout, widget: hidden, default: post }
      - { label: Title, name: title, widget: string }
      - { label: Publish Date, name: date, widget: datetime }
      - { label: Body, name: body, widget: markdown }
  - name: pages
    label: Pages
    editor:
      preview: false
    files:
      - label: Index Page
        name: index
        file: src/index.md
        fields:
          - { label: Layout, name: title, widget: hidden, default: home }
          - { label: Body, name: body, widget: markdown }
      - label: About Page
        name: about
        file: src/about.md
        fields:
          - { label: Title, name: title, widget: hidden, default: About }
          - { label: Layout, name: layout, widget: hidden, default: page }
          - { label: Permalink, name: permalink, widget: string, default: "/about/" }
          - { label: Body, name: body, widget: markdown }
```

For more information on these config options, checkout the [Netlify CMS Configuration Options Documentation](https://www.netlifycms.org/docs/configuration-options/)

I decided what fields needed to be used by looking at the frontmatter in the example pages that Bridgetown created with the new site.

For our posts, this looks like:

```md
---
title: "Your First Post on Bridgetown"

categories: updates
---
```

and in our config for Netlify CMS:

```yml
fields:
  - { label: Layout, name: layout, widget: hidden, default: post }
  - { label: Title, name: title, widget: string }
  - { label: Publish Date, name: date, widget: datetime }
  - { label: Body, name: body, widget: markdown }
```

I neglected to add categories, which would be [a great contribution to this repository](https://github.com/andrewmcodes/bridgetown-netlify-cms-starter) if you are interested!

You should now be able to navigate to `http://localhost:4000/admin` in your browser and see this page:

![Netlify CMS Admin Page](https://dev-to-uploads.s3.amazonaws.com/i/arv5vukbo7y6lr5r8zsi.jpg)

In order to use the CMS locally, run `npx netlify-cms-proxy-server` in a separate terminal window or run `yarn add -D netlify-cms-proxy-server` and modify `start.js`:

```diff
concurrently([
  { command: "yarn webpack-dev", name: "Webpack", prefixColor: "yellow"},
  { command: "sleep 4; yarn serve --port " + port, name: "Bridgetown", prefixColor: "green"},
-  { command: "sleep 8; yarn sync", name: "Live", prefixColor: "blue"}
+  { command: "sleep 8; yarn sync", name: "Live", prefixColor: "blue"},
+  { command: "sleep 12; yarn netlify-cms-proxy-server", name: "CMS", prefixColor: "red"}
], {
  restartTries: 3,
  killOthers: ['failure', 'success'],
}).then(() => { console.log("Done.");console.log('\033[0G'); }, () => {});
```

Now the CMS will start with the rest of your server. You can play with it locally and check for errors, but the real power is once we get this live!

### Create GitHub repo

Create a new GitHub repository and push this code to your default branch. If you have the [GitHub CLI](https://github.com/cli/cli), that process would look something like:

```bash
# I am using main as my default branch
gco -b main
git add .
git commit -m "feat: :tada: Initial" -m "Initial commit"
gh repo create bridgetown-netlify-cms-starter --public
git push --set-upstream origin main
```

### Create Netlify site

1. Log in to Netlify
1. Press the 'New site from Git' button
1. Choose your repository
1. Set your build command to `yarn deploy`
1. Set the publish directory to `output`
1. Deploy site

![Alt Text](https://dev-to-uploads.s3.amazonaws.com/i/n0mh8jeu3wedgfz81wwt.jpg)

### Netlify Identity

In order to log in to our CMS, we need to enable Netlify Identity on the `Identity` tab for our new site.

#### Registration preferences

**Before setting this, make sure you have created your first user to make your life easier (next section)**
I would recommend setting this to invite only vs open once you have a configured user.

#### External providers

I find it is way easier to use an external provider (like GitHub) and highly suggest doing the same. There is a weird bug with the invitation links that I haven't solved yet for normal signups and this will remove that headache.

#### Services

Enable the Git Gateway to allow Netlify to connect your site to GitHub's API, which is required for using Netlify CMS.

### Using the CMS

Navigate to your deployed site and go to the `/admin` route. For example, the admin page for this starter is located at `https://bridgetown-netlify-cms-starter.netlify.app/admin`

Your page should look like:

![Netlify CMS login](https://dev-to-uploads.s3.amazonaws.com/i/re1u6hkm71qy720w10l2.jpg)

Click the `Continue with GitHub` button. After you authenticate with GitHub, you should be redirected to your CMS!

![Netlify CMS](https://dev-to-uploads.s3.amazonaws.com/i/jfdgw5nazt1bzuwadnhn.jpg)

**Note:** At this point, I would go back to your site settings and set the registration preferences to **invite only**!

### Publishing

From here you should be all set! You can create a new blog post, edit content on your pages, upload images, and more!

After changing the index page for example, hit the `publish` button at the top of the page and publish now.

What this will do is add a commit to your GitHub repo with the changes and if Netlify is set to deploy your default branch (this is default behavior), the Netlify will automatically redeploy the site with the changes.

To go back to your site, change your url to the root, or click the user icon in the top right of the CMS and log out.

**Note:** there is some weird bug that pops up after it logs you out. Either refresh the page or just change the url back to your root url.

After the deploy finishes (it is very quick if you followed along), the content you changed or added should be reflected! I updated the index page, and my site now looks like:

![Alt Text](https://dev-to-uploads.s3.amazonaws.com/i/y2q7dh2fqorxdnjxs151.jpg)

### Wrap up

From this point, you can continue changing your Bridgetown site, and configure the CMS config file as needed. Hopefully this gives you all the excuse you need to try [Bridgetown](https://www.bridgetownrb.com)! If you encounter any issues or find a bug, feel free to report it on the [repository](https://github.com/andrewmcodes/bridgetown-netlify-cms-starter).

You can find the demo for this project [here](https://bridgetown-netlify-cms-starter.netlify.app/).

Happy coding!
