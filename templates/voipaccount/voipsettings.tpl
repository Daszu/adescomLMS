{extends file="layout.html"}
{block name=title}::: LMS :{$layout.pagetitle|striphtml} :::{/block}
{block name=module_content}
<H1>{$layout.pagetitle}</H1>
<FORM NAME="voipsettings" METHOD="POST" ACTION="?m=voipsettings">
    <INPUT type="submit" class="hiddenbtn">

    <TABLE class="lmsbox">
        <TR CLASS="DARK">
            <TD WIDTH="1%" CLASS="FLEFTU"></TD>
            <TD WIDTH="1%" CLASS="FBT" NOWRAP><B>{t}Default absolute monthly limit:{/t}</B></TD>
            <TD WIDTH="98%" CLASS="FRIGHTU"><INPUT TYPE="TEXT" NAME="settings[default_absolute_cost_limit]" VALUE="{$settings.default_absolute_cost_limit}" {tip text="Enter default absolute monthly limit" trigger="default_absolute_cost_limit"}></TD>
        </TR>				
        <TR CLASS="DARK">
            <TD WIDTH="100%" CLASS="FBOTTOMU" COLSPAN="3" ALIGN="RIGHT">
                <A HREF="javascript:document.voipsettings.submit();" ACCESSKEY="s">{t}Submit{/t} <IMG SRC="img/save.gif" alt=""></A>
            </TD>
        </TR>	
    </TABLE>
</FORM>
{if $message}
<div>
    <p>{$message}</p>
</div>
{/if}
{/block}