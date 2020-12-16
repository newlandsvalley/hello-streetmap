hello-streetmap
===============

Basic scaffolding for using [openlayers](https://openlayers.org/) in order to display a map powered by [OpenStreetMap](https://www.openstreetmap.org/).

Dependencies
------------

First install parcel as a bundler, which for me was managed by:

```
    npm install -g parcel-bundler
```

and then install the openlayers API:

```
    npm install ol
```

To Build
--------

Continous builds of the purescript component can be enabled using:


```
    spago build --watch
```

Development builds into the _dist_ directory of the entire module can be enabled using:

```
    npm run dev
```

and then navigating to the appropriate localhost URL as indicated by parcel.

Production builds are enabled using:

```
    npm run build
```

However, I have a slight issue with parcel for production builds. The reference to the bundled js file is prefaced with a forward slash.  I host all my purescript browser applications on Apache, which is not finding the bundle unless I remove the slash.
