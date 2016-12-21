## Nemucod Decrypt
A Ruby tool to decrypt Nemucod ransomware.

## Development Status

- [x] Key derivation and file decryption
- [ ] Passing parameters in from a command line
- [ ] Packaged up as a gem

## Background

A ransomware dubbed Nemucod or DECRYPT.txt rapidly encrypts files using a weak XOR encryption. Without the key, it is still difficult to recover the ransomed data. However, the XOR encryption key is easily derived by comparing a known good file to its encrypted counterpart. I read about the encryption technique and the possibility of deriving a key and decrypting files manually sounded like a great learning experience, so here it is.

The Nemucod ransomware is easy to identidy by a signature text file it leaves on the Windows desktop of a victim computer. I've redacted some parts of this sample:

> ATTENTION!
> 
> All your documents, photos, databases and other important personal files were encrypted using strong RSA-1024 algorithm with a unique key. To restore your files you have to pay <amount> BTC (bitcoins).
> Please follow this manual:
> 
> 1. Create Bitcoin wallet here: https://blockchain.info/wallet/new
> 2. Buy <amount> BTC with cash, using search here: https://localbitcoins.com/buy_bitcoins
> 3. Send <amount> BTC to this Bitcoin address: <address>
> 4. Open one of the following links in your browser to download decryptor:  <website>  <website>  <website>  <website>  <website>
> 5. Run decryptor to restore your files.
> 
> PLEASE REMEMBER:
> 
> - If you do not pay in 3 days YOU LOOSE ALL YOUR FILES.
> - Nobody can help you except us.
> - It's useless to reinstall Windows, update antivirus software, etc.
> - Your files can be decrypted only after you make payment.
> - You can find this manual on your desktop (DECRYPT.txt).

A family member recently became a victim of this scam and asked me for help, but the decryptor available didn't look like it'd run on a mac or linux. I'm always interested in diving into some malware and bit math, so I built this ruby tool to derive the key and decrypt ransomed files.

Send me a note if it proves to be of any use to you.

Sources:

- https://www.bleepingcomputer.com/news/security/decryptor-released-for-the-nemucod-trojans-crypted-ransomware/