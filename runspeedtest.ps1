##### include config #####
. ".\config.ps1"

##### �萔�Z�b�g #####
$URI = 'https://gw.machinist.iij.jp/endpoint'
$HEADER = @{
    Authorization = "Bearer $API_KEY"
}

##### �f�[�^���� #####
$RESULT = (.\speedtest.exe -s 48463 -f csv --output-header | ConvertFrom-Csv | Select-Object @{
        name='Download'
        expr={[Int]$_.download * 8}
    },
    @{
        name='RTT'
        expr={$_.'idle latency'}
    })
$DATA = @{
    agent_id = $AGENT_ID
    metrics = @(
        @{
            name = "Download"
            namespace = "Speedtest.net"
            data_point = @{
                value = $RESULT.Download
            }
        },
        @{
            name = "RTT"
            namespace = "Speedtest.net"
            data_point = @{
                value = [double]$RESULT.RTT
            }
        }
    )
}
$BODY = $DATA | ConvertTo-Json -Depth 5  # Depth�I�v�V������������data_point����JSON������Ȃ�

echo $URI
echo $BODY

##### �f�[�^���M #####
Invoke-RestMethod -Method Post -ContentType 'application/json' -Headers $HEADER -Uri $URI -Body $BODY
