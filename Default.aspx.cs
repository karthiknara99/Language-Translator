using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Net;
using System.IO;
using System.Media;
using System.Text;

public partial class _Default : System.Web.UI.Page
{
    // Before running the application, input the secret key for your subscription to Translator Text Translation API.
    private const string TEXT_TRANSLATION_API_SUBSCRIPTION_KEY = "b607858a081b4e61a95ae10c2cd0f073";

    // Object to get an authentication token
    private AzureAuthToken tokenProvider;
    // Cache language friendly names
    private string[] friendlyName = { " " };
    // Cache list of languages for speech synthesis
    private List<string> speakLanguages;
    // Dictionary to map language code from friendly name
    private Dictionary<string, string> languageCodesAndTitles = new Dictionary<string, string>();

    // Error Count
    private static int errorCount = 0;

    protected void Page_Load(object sender, EventArgs e)
    {
        tokenProvider = new AzureAuthToken(TEXT_TRANSLATION_API_SUBSCRIPTION_KEY);
        GetLanguagesForTranslate(); //List of languages that can be translated
        GetLanguageNamesMethod(tokenProvider.GetAccessToken(), friendlyName); //Friendly name of languages that can be translated
        GetLanguagesForSpeakMethod(tokenProvider.GetAccessToken()); //List of languages that have a synthetic voice for text to speech
        enumLanguages(); //Create the drop down list of langauges
    }

    //*****POPULATE COMBOBOX*****
    private void enumLanguages()
    {
        //run a loop to load the combobox from the dictionary
        var count = languageCodesAndTitles.Count;

        for (int i = 0; i < count; i++)
        {
            LanguageSelectionDropDownList.Items.Add(languageCodesAndTitles.ElementAt(i).Key);
            LanguageSelectionDropDownList.Items[i].Attributes.Add("class", "languageSelectionDropDownItem");
        }
    }

    protected void TranslateButton_Click(object sender, System.Web.UI.ImageClickEventArgs e)
    {
        ErrorLabel.Visible = false;
        ErrorCountLabel.Visible = false;
        string languageCode;
        languageCodesAndTitles.TryGetValue(LanguageSelectionDropDownList.SelectedItem.Text, out languageCode); //get the language code from the dictionary based on the selection in the combobox

        if (languageCode == null)  //in case no language is selected.
        {
            languageCode = "en";
        }

        //*****BEGIN CODE TO MAKE THE CALL TO THE TRANSLATOR SERVICE TO PERFORM A TRANSLATION FROM THE USER TEXT ENTERED INCLUDES A CALL TO A SPEECH METHOD*****

        string txtToTranslate = TextTranslationFrom.Text;

        string uri = string.Format("http://api.microsofttranslator.com/v2/Http.svc/Translate?text=" + System.Web.HttpUtility.UrlEncode(txtToTranslate) + "&to={0}", languageCode);

        WebRequest translationWebRequest = WebRequest.Create(uri);

        translationWebRequest.Headers.Add("Authorization", tokenProvider.GetAccessToken()); //header value is the "Bearer plus the token from ADM

        WebResponse response = null;

        response = translationWebRequest.GetResponse();

        Stream stream = response.GetResponseStream();

        Encoding encode = Encoding.GetEncoding("utf-8");

        StreamReader translatedStream = new StreamReader(stream, encode);

        System.Xml.XmlDocument xTranslation = new System.Xml.XmlDocument();

        xTranslation.LoadXml(translatedStream.ReadToEnd());

        TextTranslationTo.Text = /*"Translation -->   " +*/ xTranslation.InnerText;

        if (speakLanguages.Contains(languageCode) && txtToTranslate != "")
        {
            //call the method to speak the translated text
            SpeakMethod(tokenProvider.GetAccessToken(), xTranslation.InnerText, languageCode);
        }
    }

    //*****SPEECH CODE*****
    private void SpeakMethod(string authToken, string textToVoice, String languageCode)
    {
        string translatedString = textToVoice;

        string uri = string.Format("http://api.microsofttranslator.com/v2/Http.svc/Speak?text={0}&language={1}&format=" + HttpUtility.UrlEncode("audio/wav") + "&options=MaxQuality", translatedString, languageCode);

        WebRequest webRequest = WebRequest.Create(uri);
        webRequest.Headers.Add("Authorization", authToken);
        WebResponse response = null;
        try
        {
            response = webRequest.GetResponse();

            using (Stream stream = response.GetResponseStream())
            {
                using (SoundPlayer player = new SoundPlayer(stream))
                {
                    player.PlaySync();
                }
            }
        }
        catch
        {
            throw;
        }
        finally
        {
            if (response != null)
            {
                response.Close();
                response = null;
            }
        }
    }

    //*****CODE TO GET TRANSLATABLE LANGAUGE CODES*****
    private void GetLanguagesForTranslate()
    {
        string uri = "http://api.microsofttranslator.com/v2/Http.svc/GetLanguagesForTranslate";
        WebRequest WebRequest = WebRequest.Create(uri);
        WebRequest.Headers.Add("Authorization", tokenProvider.GetAccessToken());

        WebResponse response = null;

        try
        {
            response = WebRequest.GetResponse();
            using (Stream stream = response.GetResponseStream())
            {
                System.Runtime.Serialization.DataContractSerializer dcs = new System.Runtime.Serialization.DataContractSerializer(typeof(List<string>));
                List<string> languagesForTranslate = (List<string>)dcs.ReadObject(stream);
                friendlyName = languagesForTranslate.ToArray(); //put the list of language codes into an array to pass to the method to get the friendly name.
            }
        }
        catch
        {
            throw;
        }
        finally
        {
            if (response != null)
            {
                response.Close();
                response = null;
            }
        }
    }

    //*****CODE TO GET TRANSLATABLE LANGAUGE FRIENDLY NAMES FROM THE TWO CHARACTER CODES*****
    private void GetLanguageNamesMethod(string authToken, string[] languageCodes)
    {
        string uri = "http://api.microsofttranslator.com/v2/Http.svc/GetLanguageNames?locale=en";
        // create the request
        HttpWebRequest request = (HttpWebRequest)WebRequest.Create(uri);
        request.Headers.Add("Authorization", tokenProvider.GetAccessToken());
        request.ContentType = "text/xml";
        request.Method = "POST";
        System.Runtime.Serialization.DataContractSerializer dcs = new System.Runtime.Serialization.DataContractSerializer(Type.GetType("System.String[]"));
        using (System.IO.Stream stream = request.GetRequestStream())
        {
            dcs.WriteObject(stream, languageCodes);
        }
        WebResponse response = null;
        try
        {
            response = request.GetResponse();

            using (Stream stream = response.GetResponseStream())
            {
                string[] languageNames = (string[])dcs.ReadObject(stream);

                for (int i = 0; i < languageNames.Length; i++)
                {
                    languageCodesAndTitles.Add(languageNames[i], languageCodes[i]); //load the dictionary for the combo box
                }
            }
        }
        catch
        {
            throw;
        }
        finally
        {
            if (response != null)
            {
                response.Close();
                response = null;
            }
        }
    }

    private void GetLanguagesForSpeakMethod(string authToken)
    {
        string uri = "http://api.microsofttranslator.com/v2/Http.svc/GetLanguagesForSpeak";
        HttpWebRequest httpWebRequest = (HttpWebRequest)WebRequest.Create(uri);
        httpWebRequest.Headers.Add("Authorization", authToken);
        WebResponse response = null;
        try
        {
            response = httpWebRequest.GetResponse();
            using (Stream stream = response.GetResponseStream())
            {
                System.Runtime.Serialization.DataContractSerializer dcs = new System.Runtime.Serialization.DataContractSerializer(typeof(List<string>));
                speakLanguages = (List<string>)dcs.ReadObject(stream);
            }
        }
        catch
        {
            throw;
        }
        finally
        {
            if (response != null)
            {
                response.Close();
                response = null;
            }
        }
    }

    protected void CompleteButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("https://ufl.qualtrics.com/jfe/form/SV_ahh3w7Ys2rKBoTr");
    }

    protected void ErrorButton_Click(object sender, EventArgs e)
    {
        errorCount++;
        ErrorLabel.Visible = true;
        ErrorCountLabel.Text = "Error Count: " + errorCount;
        ErrorCountLabel.Visible = true;
    }

}