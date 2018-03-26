<#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    NAME--------: Send-psmail
    AUTHER------: Garvey Snow
    VERSION-----: 1.2
    DESCRIPTION-: Function wrapper for sending powershell mail messages
    DEPENDANCIES: None
	BUILD ENV   : Powershell Version 5.0.10586.117
    LICENCE-----: GNU GENERAL PUBLIC LICENSE
    KB: o-»       
	UPDATE: 01/02/2017 @ 16:11
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////#>
function send-psmail()
{

    param(
        [string[]][parameter(mandatory=$true)]$from,
        [string[]][parameter(mandatory=$true)]$to,
        [string[]][parameter(mandatory=$true)]$body,
        [string[]][parameter(mandatory=$true)]$subject,
        [string[]][parameter(mandatory=$true)]$smtp,
        [bool[]][parameter(mandatory=$false)]$htmlBody
    )
    #/////////////////////////////////////////////////
    #///////( Mailmessage Class Object)//////////////////////////
    $m_message = [System.Net.Mail.MailMessage]::new($from,$to,$subject,$body)
   
    #/////////////////////////////////////////////////
    #///////( Populate propertes )//////////////////////////
    $m_message.IsBodyHtml=$true;

    #//////////////////////////////////////////////
    #///////////( SMTP Object )////////////////////
    $smtp_object = [Net.Mail.SmtpClient]::new($smtp)
    
    # ( SEND MAIL MESSAGE )
    $smtp_object.Send($m_message)
}