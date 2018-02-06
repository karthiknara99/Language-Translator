<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Language Translator</title>
    <style type="text/css">

        .body{
            background-image: url('Images/background.jpg');
            background-repeat: no-repeat;
            background-size: cover;
        }

        .fullWidth{
            width: 100%;
        }

        .halfWidth{
            width: 50%;
        }

        .panelSpaceLess{
            width: 100%;
            margin: 20px 0px;
        }

        .panelSpaceMore{
            width: 100%;
            margin: 60px 0px;
        }

        .headingLabel {
            font-family: 'Trebuchet MS';
            font-size: 40px;
            font-weight: normal;
            color: white;
            line-height: 200%;
            display: block;
            text-align: center;
        }

        .languageSelectionLabel {
            font-family: 'Trebuchet MS';
            font-size: 20px;
            font-weight: normal;
            color: white;
            line-height: 200%;
            float: right;
            margin-right: 10px;
        }

        .languageSelectionDropDown {
            background-color: rgba(0, 0, 0, 0.3);
            font-family: 'Trebuchet MS';
            font-size: 18px;
            font-weight: normal;
            color: white;
            border: 0.5px solid #808080;
            border-radius: 3px;
            margin-left: 10px;
            padding: 5px;
        }

        .languageSelectionDropDownItem { 
            color: black;
        }

        .textTranslationTextBoxFrom {
            background-color: rgba(0, 0, 0, 0.3);
            width: 70%;
            min-width: 250px;
            min-height: 200px;
            font-family: 'Trebuchet MS';
            font-size: 16px;
            font-weight: normal;
            color: white;
            border: none;
            border-radius: 15px;
            padding: 12px 12px 0px 12px;
            float: right;
            overflow: hidden;
        }

        translateButtonCell{
            min-width: 74px;
            min-height: 74px;
        }

        .translateButton {
            vertical-align: central;
        }

        .translateButton:hover {
            cursor:pointer;
        }

        .textTranslationTextBoxTo {
            background-color: rgba(0, 0, 0, 0.3);
            width: 70%;
            min-width: 250px;
            min-height: 200px;
            font-family: 'Trebuchet MS';
            font-size: 16px;
            font-weight: normal;
            color: white;
            border: none;
            border-radius: 15px;
            padding: 12px 12px 0px 12px;
            float: left;
            overflow: hidden;
        }

        .errorButton {
            background-color: #ed1c24; /* Red */
            font-family: 'Trebuchet MS';
            font-size: 17px;
            font-weight: normal;
            color: white;
            text-align: center;
            text-decoration: none;
            border: none;
            border-radius: 7px;
            padding: 15px 32px;
        }

        .errorButton:hover {
            cursor:pointer;
        }

        .completeButton {
            background-color: #4caf50; /* Green */
            font-family: 'Trebuchet MS';
            font-size: 17px;
            font-weight: normal;
            color: white;
            text-align: center;
            text-decoration: none;
            border: none;
            border-radius: 7px;
            padding: 15px 32px;
        }

        .completeButton:hover {
            cursor:pointer;
        }

        .errorLabel {
            font-family: 'Trebuchet MS';
            font-size: 14px;
            font-weight: normal;
            color: white;
            display: block;
            text-align: center;
            padding-top: 24px;
        }

        .errorCountLabel {
            font-family: 'Trebuchet MS';
            font-size: 14px;
            font-weight: normal;
            color: white;
            line-height: 200%;
            display: block;
            text-align: center;
        }

    </style>
</head>
<body class="body">
    <form id="form1" runat="server">

        <asp:Panel ID="HeadingPanel" runat="server" CssClass="panelSpaceLess">
            <asp:Table ID="HeadingTable" runat="server" CssClass="fullWidth">
                <asp:TableRow ID="HeadingTableRow" runat="server" CssClass="fullWidth">
                    <asp:TableCell ID="HeadingTableRowCell" runat="server" CssClass="fullWidth">
                        <asp:Label ID="HeadingLabel" runat="server" CssClass="headingLabel" Text="Language Translator"></asp:Label>
                    </asp:TableCell>
                </asp:TableRow>
            </asp:Table>
        </asp:Panel>

        <asp:Panel ID="LanguageSelectionPanel" runat="server" CssClass="panelSpaceLess">
            <asp:Table ID="LanguageSelectionTable" runat="server" CssClass="fullWidth">
                <asp:TableRow ID="LanguageSelectionTableRow" runat="server" CssClass="fullWidth">
                    <asp:TableCell ID="LanguageSelectionTableRowCell1" runat="server" CssClass="halfWidth">
                        <asp:Label ID="LanguageSelectionLabel" runat="server" CssClass="languageSelectionLabel" Text="Translate to language:"></asp:Label>
                    </asp:TableCell>
                    <asp:TableCell ID="LanguageSelectionTableRowCell2" runat="server" CssClass="halfWidth">
                        <asp:DropDownList ID="LanguageSelectionDropDownList" runat="server" CssClass="languageSelectionDropDown"></asp:DropDownList>
                    </asp:TableCell>
                </asp:TableRow>
            </asp:Table>
        </asp:Panel>

        <asp:Panel ID="TextTranslationPanel" runat="server" CssClass="panelSpaceMore">
            <asp:Table ID="TextTranslationTable" runat="server" CssClass="fullWidth">
                <asp:TableRow ID="TextTranslationTableRow" runat="server" CssClass="fullWidth">
                    <asp:TableCell ID="TextTranslationTableRowCell1" runat="server">
                        <asp:TextBox ID="TextTranslationFrom" runat="server" CssClass="textTranslationTextBoxFrom" TextMode="MultiLine" Placeholder="Enter the text to be translated. (Language is auto-detected)"></asp:TextBox>
                    </asp:TableCell>
                    <asp:TableCell ID="TextTranslationTableRowCell2" runat="server" CssClass="translateButtonCell" HorizontalAlign="Center">
                        <asp:ImageButton ID="TranslateButton" runat="server" CssClass="translateButton" ImageUrl="~/Images/rightArrow_64px.png" ToolTip="Convert" OnClick="TranslateButton_Click" />
                    </asp:TableCell>
                    <asp:TableCell ID="TextTranslationTableRowCell3" runat="server">
                        <asp:TextBox ID="TextTranslationTo" runat="server" CssClass="textTranslationTextBoxTo" TextMode="MultiLine" Placeholder="The translated text will appear here." ReadOnly="true"></asp:TextBox>
                    </asp:TableCell>
                </asp:TableRow>
            </asp:Table>
        </asp:Panel>

        <asp:Panel ID="ButtonPanel" runat="server" CssClass="panelSpaceMore">
            <asp:Table ID="ButtonTable" runat="server" CssClass="fullWidth">
                <asp:TableRow ID="ButtonTableRow1" runat="server" CssClass="fullWidth">
                    <asp:TableCell ID="ButtonTableRow1Cell1" runat="server" CssClass="fullWidth" HorizontalAlign="Center">
                        <asp:Button ID="ErrorButton" runat="server" CssClass="errorButton" Text="Error" ToolTip="Error" OnClick="ErrorButton_Click" />
                        &nbsp; &nbsp;
                        <asp:Button ID="CompleteButton" runat="server" CssClass="completeButton" Text="Complete Interaction" ToolTip="Complete" OnClick="CompleteButton_Click" />
                    </asp:TableCell>
                </asp:TableRow>
                <asp:TableRow ID="ButtonTableRow2" runat="server" CssClass="fullWidth">
                    <asp:TableCell ID="ButtonTableRow2Cell1" runat="server" CssClass="fullWidth">
                        <asp:Label ID="ErrorLabel" runat="server" CssClass="errorLabel" Text="Sorry about that!! Please try again rephrasing the input text!!" Visible="false"></asp:Label>
                    </asp:TableCell>
                </asp:TableRow>
                <asp:TableRow ID="ButtonTableRow3" runat="server" CssClass="fullWidth">
                    <asp:TableCell ID="ButtonTableRow3Cell1" runat="server" CssClass="fullWidth">
                        <asp:Label ID="ErrorCountLabel" runat="server" CssClass="errorCountLabel" Text="Error Count: 0" Visible="false"></asp:Label>
                    </asp:TableCell>
                </asp:TableRow>
            </asp:Table>
        </asp:Panel>

    </form>
</body>
</html>
