#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <openssl/md5.h>

/*const char *passwd = "abc";

int main()
{
    int i;
    unsigned char result[MD5_DIGEST_LENGTH];

    MD5(passwd, strlen(passwd), result);

    // Password output
    printf("Plaintext: %s\n", passwd);
    // MD5 output
    printf("MD5 Hash:  ");
    for (i = 0; i < MD5_DIGEST_LENGTH; i++)
        printf("%02x", result[i]);
    printf("\n");

    return EXIT_SUCCESS;
}*/

void crypt_md5(const char *passwd, unsigned char **resultp)
{
    (*resultp) = (unsigned char *)calloc(MD5_DIGEST_LENGTH, sizeof(unsigned char));
    MD5(passwd, strlen(passwd), (*resultp));
}

int main(void)
{
    FILE *fp;
    char *line = NULL;
    size_t len = 0;
    ssize_t read;
    size_t counter = 0;

    fp = fopen("/home/tlx3m3j/Documents/Retro_Computing/10-million-password-list-top-1000000.txt", "r");
    if (fp == NULL)
        exit(EXIT_FAILURE);

    while ((read = getline(&line, &len, fp)) != -1)
    {
        int i;
        unsigned char *result;
        crypt_md5(line, &result);
        for (i = 0; i < MD5_DIGEST_LENGTH; i++)
            printf("%02x", result[i]);
        printf("\n");
        free(result);
        counter = counter + 1;
    }

    fclose(fp);
    if (line)
        free(line);

    printf("Results: %ld\n", counter);

    exit(EXIT_SUCCESS);
}