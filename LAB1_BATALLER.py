text = str(input('Enter word to reverse: '))

def encrypt_text(text):
    encrypted_text = ''
    while text != '':
        encrypted_text += text[-1]
        text = text[0:len(text) - 1]

    return encrypted_text

def decrypt_text(text):
    return encrypt_text(text)

print(f'Encrypted Text: {encrypt_text(text)}')
print(f'Decrypted Text: {decrypt_text(encrypt_text(text))}')