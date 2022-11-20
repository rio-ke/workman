# Debugging Bash Shell Scripts

**Task-setup**

- Downloading bashdb
- Installing a newer bash version
- Compiling (with make) and installing bashdb
- Installing vs-code and vs-code bash-debug plugin
- Setting up debugging in vs-code
- Finally seeing the debugger in action

**_Downloading bashdb_**

- Click [sourceforge repo of bashdb](https://sourceforge.net/projects/bashdb/files/bashdb/)

- Download the \*tar.gz file in this[extension](https://sourceforge.net/projects/bashdb/files/bashdb/4.4-0.94/bashdb-4.4-0.94.tar.gz/download)

- Now choose the latest folder (When this article was written the latest was 4.4-0.94) and open it.

- Download the \*tar.gz

- Now you need to extract Downloaded file. In your terminal

**_extract method_**

```bash
cd folder-where-you-downloaded #Download folder
```

```bash
tar -xvf bashdb-*.tar.gz
```

```bash
ls
cd bashdb-4.4-0.94 #bashdb-extracted-folder-name-see-in-dir`
```

_Installing a newer bash version_

- Check your bash version by running in your terminal

```bash
bash --version
which bash
```

- If your version is above 4.4.12 then skip the rest of this step. Else install latest bash.

```bash
export PATH=/usr/local/bin:$PATH
```

**_Compiling and installing bashdb_**

```
cd bashdb-4.4-0.94
./configure
```

## make installation for configuration
