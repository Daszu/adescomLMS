{extends file="layout.html"}
{block name=title}::: LMS : {$layout.pagetitle|striphtml} :::{/block}
{block name=module_content}
<h1>{$layout.pagetitle}</h1>
<p>{t}Internal Server Error has occured!{/t}</p>
<p>{$error_message}</p>
<p>{t}Please contact Adescom support.{/t}</p>
{/block}