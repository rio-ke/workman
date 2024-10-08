Generate a GPG Key
---

***To generate a GPG key in Linux terminal***

```cmd
gpg --gen-key
```
* Give git Username and mail-Id for GPG KEy
![image](https://github.com/rio-ke/workman/assets/88568938/e8ee7a96-24b9-4226-baf2-e4af0230ac87)

*List Your GPG Keys*

```cmd
gpg --list-secret-keys --keyid-format LONG
```

*Add the GPG Key to GitHub*

* `Copy your GPG key` from list above and into the command

```cmd
gpg --armor --export 1234ABCD
```

* Copy the GPG key output.

* Go to GitHub `Settings`.

* Click on `SSH and GPG keys`

* Click `New GPG key` and paste your GPG key

*Configure Git to Use the GPG Key*

```cmd
git config --global user.signingkey 1234ABCD
git config --global commit.gpgSign true
```

```cmd
git commit -S -m "Your commit message"
```

```cmd
git config --global commit.gpgSign true
```

```cmd
git log --show-signature
```

***Remove GPG Key Locally***

* To remove a GPG key from both your local machine and your GitHub account


*List GPG Keys*

```cmd
gpg --list-secret-keys --keyid-format LONG
```

*Delete GPG Key*

```cmd
gpg --delete-secret-key KEY_ID_replace
```

Remove GPG Public Key

```cmd
gpg --delete-key KEYID
```

***Remove GPG Key from GitHub***

* Go to GitHub `Settings`

* Click on `SSH and GPG keys`

* Locate the GPG key you want to remove and click `Delete`


***Update Git Configuration***

*Remove GPG Configuration*

```cmd
git config --global --unset user.signingkey
git config --global --unset commit.gpgSign
```
Clear GPG Cache (Optional)

```cmd
gpgconf --kill gpg-agent
```
