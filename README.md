# Cosmos Testnet Faucet

This faucet app allows anyone who passes a captcha to request tokens for a Cosmos account address.

## How to deploy a faucet

1. Clone this repository locally

2. Create Google reCAPTCHA v2 keys.
    - [Go here](https://www.google.com/recaptcha/admin/create). *(If you want to use existing keys, [go here](https://www.google.com/recaptcha/admin))*
    - Fill out the form. Make sure you select `reCAPTCHA v2 - "I'm not a robot" Checkbox`.
    - *Note - you can start out with google's test API keys:*
        - Site key: `6LeIxAcTAAAAAJcZVRqyHh71UMIEGNQ_MXjiZKhI`
        - Secret key: `6LeIxAcTAAAAAGG-vFI1TnRWxMZNFuojJ4WifJWe`

3. Install [quicksilverd](https://github.com/ingenuity-build/quicksilver/releases) on the server. `quicksilverd`'s version has to be compatible with the testnet.

4. Configure `quicksilverd`:
    ```
    quicksilverd config keyring-backend test
    ```

3. Create the the faucet account on the machine that is going to run the faucet.
    ```
    quicksilverd keys add <name of the account> --keyring-backend=test
    ```

4. Make sure the faucet account have funds. The faucet basically performs a `tx send` for every token request, so make sure the faucet account have enough tokens (more tokens could be added later by sending more funds to the faucet account).

5. Copy the `.env` template to the `/frontend` directory
    ```
    cp .env.template ./frontend/.env
    ```

6. Change the `.env` parameters as you see fit. Parameter description:
    - `VUE_APP_CHAIN` - Should hold the `chain-id`
    - `FAUCET_CHAIN` - Should hold the `chain-id`
    - `VUE_APP_RECAPTCHA_SITE_KEY` - Google reCAPTCHA Site Key
    - `FAUCET_RECAPTCHA_SECRET_KEY` - Google reCAPTCHA Secret Key
    - `VUE_APP_CLAIM_URL` - URL for the claim server request. Leave as is.
    - `FAUCET_PUBLIC_URL` - The URL that the server is going to listen to. Leave as is to use Caddy later.
    - `FAUCET_AMOUNT_FAUCET` - Amount of tokens to send on each request. Should specify amount+denom e.g. 123uscrt.
    - `FAUCET_KEY` - The account alias that will hold the faucet funds.
    - `FAUCET_NODE` - Address of a full node/validator that the CLI will send txs to e.g. tcp://domain.name:26657
    - `LOCAL_RUN` - Option for local run for debug. Not supported for now, should leave as `false`.
    - Other parameters should be left unchanged.

7. Build:
    ```
    make all
    ```

8. Deploy to server. You can do it manually by copying the `bin/` directory or run `make deploy` (make sure to change the makefile to match your server's address i.e. `scp -r ./bin user-name@your.domain:~/`)

10. (optional) Configure [Caddy](https://caddyserver.com/docs/). You can use [this](https://github.com/Errorist79/faucet-qck/blob/master/caddy/Caddyfile) as a simple template.

11. (optional) You can start the server by running the `./path/to/bin/faucet` binary. It is recommended to create a systemd unit. For example (change parameters for your own deployment):
    ```
    [Unit]
    Description=Faucet web server
    After=network.target

    [Service]
    Type=simple
    WorkingDirectory=/home/ubuntu/faucet-qck/bin
    ExecStart=/home/ubuntu/faucet-qck/bin/faucet
    User=ubuntu
    Restart=always
    StartLimitInterval=0
    RestartSec=3
    LimitNOFILE=65535
    AmbientCapabilities=CAP_NET_BIND_SERVICE

    [Install]
    WantedBy=multi-user.target
    ```
