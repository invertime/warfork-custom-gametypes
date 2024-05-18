# warfork-custom-gametypes

Custom gametypes for warfork

## How to use

You can use the `utils/build.sh` script (you need to have 7zip installed):

```bash
./utils/build.sh
```

It will create an archive folder (if it doesn't already exist) where you will be able to found all the pk3 archive (to put in your `basewf` folder)

You can also compress them manually using the following command:

```bash
7z a -tzip {gametype}.pk3 ./progs/gametypes/{gametype}/*
```

where `{gametype}` is your desired gametype

> Note for windows users: you need to add the 7zip executable path in your environment variable
