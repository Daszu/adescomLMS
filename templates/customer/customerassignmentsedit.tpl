{extends file="layout.html"}
{block name=title}::: LMS :{$layout.pagetitle|striphtml} :::{/block}
{block name=module_content}
<!--// $Id$ //-->
<H1>{$layout.pagetitle}</H1>
{include file="calendar_js.html"}
{$xajax}
<SCRIPT type="text/javascript">
<!--
	function set_tariff()
	{
		var val = document.forms['assignment'].elements['assignment[tariffid]'].value;

		{if $promotionschemas}
		document.getElementById('a_schema').style.display = val == -2 ? '' : 'none';
		document.getElementById('a_schematariff').style.display = val == -2 ? '' : 'none';
		{/if}

		document.getElementById('a_tax').style.display = val == '' || val == -3 ? '' : 'none';
		document.getElementById('a_value').style.display = val == '' ? '' : 'none';
		document.getElementById('a_productid').style.display = val == '' || val == -3 ? '' : 'none';
		document.getElementById('a_name').style.display = val == '' ? '' : 'none';
		document.getElementById('a_options').style.display = val == -1 ? 'none' : '';
		var nodes_element = document.getElementById('a_nodes');
        	if (nodes_element) nodes_element.style.display = val == -1 ? 'none' : '';
		document.getElementById('a_day').style.display = val == -1 ? 'none' : '';
		{if !ConfigHelper::checkConfig('privileges.hide_finances')}
		document.getElementById('a_discount').style.display = val < -1 ? 'none' : '';
		{/if}
                document.getElementById('adescom_assignments_panel').style.display = val == -3 ? '' : 'none';
	}

{if $promotionschemas}
	function set_schema()
	{
		var sid = document.forms['assignment'].elements['assignment[schemaid]'].value,
			assignments = { {strip}
			{foreach name=fps from=$promotionschemas item=schema}
				{if $smarty.foreach.fps.index},{/if}"{$schema.id}": [{$schema.tariffs}]
			{/foreach}
			{/strip} },
			select = document.forms['assignment'].elements['assignment[stariffid]'],
			t_select = document.forms['assignment'].elements['assignment[tariffid]'],
			options = t_select.getElementsByTagName('OPTION'),
			selected = select.value,
			i, len;

		// remove old options
		select.innerHTML = '';
		// copy options from t_select element
		for (i=0, len=options.length; i<len; i++)
			if (inArray(assignments[sid], options[i].value))
				select.appendChild(options[i].cloneNode(true));

		select.value = selected;
	}
{/if}
//-->
</SCRIPT>
<FORM method="POST" name="assignment" id="assignment" action="?m={$layout.module}{if $assignment.id}&id={$assignment.id}{if $assignment.liabilityid}&lid={$assignment.liabilityid}{/if}{else}&id={$customerinfo.id}{/if}">
<INPUT type="submit" class="hiddenbtn">
<TABLE class="lmsbox">
    <THEAD>
	<TR>
		<TD style="width: 1%;">
			<IMG src="img/money.gif" alt="">
		</TD>
		<TD style="width: 1%;">
			<span class="bold">{trans("Type")}/{trans("Tariff")}:</span>
		</TD>
		<TD style="width: 98%;">
			<SELECT size="1" name="assignment[tariffid]" {tip text="Select liability type" trigger="tariffid"} onchange="set_tariff()">
				<OPTION value=""{if !$assignment.tariffid} SELECTED{/if}>- {trans("tariffless liability")} -</OPTION>
                                <OPTION value="-3"{if $assignment.tariffid == -3} SELECTED{/if}>- {t}telephone calls and subscribe{/t} -</OPTION>
				<OPTION value="-1"{if $assignment.tariffid == -1} SELECTED{/if}>{trans("- all liabilities suspended -")}</OPTION>
				{if $promotionschemas}
				<OPTION value="-2"{if $assignment.tariffid == -2} SELECTED{/if}>- {trans("per promotion schema")} -</OPTION>
				{/if}
                                {foreach from=$tariffs item=$tariff}
                                    <OPTION value="{$tariff.id}" {if $tariff.id==$assignment.tariffid}SELECTED{/if}>
                                    {$tariff.name} ({if !ConfigHelper::checkConfig('privileges.hide_finances')}{$tariff.value|money_format}, {/if}{if $tariff.upceil || $tariff.downceil}{$tariff.downceil}/{$tariff.upceil} kbit/s{/if})
                                    </OPTION>
				{/foreach}
			</SELECT>
		</TD>
	</TR>
    </THEAD>
    <TBODY>
{if $promotionschemas}
	<TR id="a_schema">
		<TD style="width: 1%;">
			<IMG src="img/promoschema.gif" alt="">
		</TD>
		<TD style="width: 1%;">
			<span class="bold">{trans("Schema")}:</span>
		</TD>
		<TD style="width: 98%;">
			<SELECT size="1" name="assignment[schemaid]" {tip text="Select promotion schema"} onchange="set_schema()">
				{foreach from=$promotionschemas item=schema}
				<OPTION value="{$schema.id}"{if $assignment.schemaid == $schema.id} SELECTED{/if}>{$schema.promotion|truncate:40:"...":true} / {$schema.name|truncate:40:"...":true}</OPTION>
				{/foreach}
			</SELECT>
		</TD>
	</TR>
	<TR id="a_schematariff">
		<TD style="width: 1%;">
			<IMG src="img/money.gif" alt="">
		</TD>
		<TD style="width: 1%;">
			<span class="bold">{trans("Tariff")}:</span>
		</TD>
		<TD style="width: 98%;">
			<SELECT size="1" name="assignment[stariffid]" {tip text="Select subscription" trigger="stariffid"}>
				{section name=t loop=$tariffs}
				<OPTION value="{$tariffs[t].id}" {if $tariffs[t].id==$assignment.stariffid}SELECTED{/if}>
				{$tariffs[t].name} ({$tariffs[t].value|money_format}{if $tariffs[t].upceil || $tariffs[t].downceil}, {$tariffs[t].downceil}/{$tariffs[t].upceil} kbit/s{/if})
				</OPTION>
				{/section}
			</SELECT>
		</TD>
	</TR>
{/if}
	<TR>
	    <TD style="width: 100%;" colspan="3" class="container">
	        <TABLE style="width: 100%;" cellpadding="0">
	            <TR>
	                <TD style="vertical-align: top; width: 50%;">
	                    <TABLE style="width: 100%;" cellpadding="3">
	<TR id="a_name">
		<TD style="width: 1%;">
			<IMG src="img/money.gif" alt="">
		</TD>
		<TD style="width: 1%; white-space: nowrap;">
			<span class="bold">{trans("Name:")}</span>
		</TD>
		<TD style="width: 98%;">
		    <INPUT type="text" name="assignment[name]" value="{if $assignment.tariffid<=0}{$assignment.name}{/if}" size="30" {tip text="Enter liability name/description (tariffless liabilities only)" trigger="name"}>
		</TD>
	</TR>
	<TR id="a_day">
		<TD style="width: 1%;">
			<IMG src="img/calendar.gif" alt="">
		</TD>
		<TD style="width: 1%; white-space: nowrap;">
			<span class="bold">{trans("Accounting:")}</span>
		</TD>
		<TD style="width: 98%;">
			<SELECT size="1" name="assignment[period]" {tip text="Select time period to account liability"}>
				{foreach from=$_PERIODS key=key item=item}
				<OPTION value="{$key}"{if $assignment.period == $key} SELECTED{/if}>{$item}</OPTION>
				{/foreach}
			</SELECT>
			<INPUT type="TEXT" name="assignment[at]" value="{if $assignment.at}{$assignment.at}{/if}" {tip text="Enter accounting time. For disposable accounting enter date in format YYYY/MM/DD, for weekly accounting enter day of week (Monday = 1), for monthly accounting enter day of month (1 to 28), for yearly accounting enter day and month in format DD/MM (15/09 means September 15th), for half-yearly DD/MM (MM <=6) and for quarterly DD/MM (MM <= 3)" trigger="at"} SIZE="8">
			{if $assignment.atwarning}
			<INPUT type="hidden" name="assignment[atwarning]" value="1">
			{/if}
		</TD>
	</TR>
	<TR id="a_period">
		<TD style="width: 1%;">
			<IMG src="img/calendar.gif" alt="">
		</TD>
		<TD style="width: 1%; white-space: nowrap;">
			<span class="bold">{trans("Period:")}</span>
		</TD>
		<TD style="width: 98%; white-space: nowrap;">
			{trans("from:")} <INPUT type="TEXT" name="assignment[datefrom]" value="{if $assignment.datefrom}{$assignment.datefrom}{/if}" OnClick="cal3.popup();" {tip text="Enter accounting start date in YYYY/MM/DD format. If you don't want to define 'From' date leave this field empty" trigger="datefrom"} SIZE="10"> 
			{trans("to:")} <INPUT type="TEXT" name="assignment[dateto]" value="{if $assignment.dateto}{$assignment.dateto}{/if}" OnClick="cal4.popup();" {tip text="Enter accounting end date in YYYY/MM/DD format. Leave this field empty if you don't want to set expiration date" trigger="dateto"} SIZE="10">
		</TD>
	</TR>
	<TR id="a_value">
		<TD style="width: 1%;">
			<IMG src="img/value.gif" alt="">
		</TD>
		<TD style="width: 1%;">
			<span class="bold">{trans("Value:")}</span>
		</TD>
		<TD style="width: 98%;">
			<INPUT type="text" name="assignment[value]" value="{if $assignment.value}{$assignment.value}{/if}" size="10" {tip text="Enter liability value (tariffless liabilities only)" trigger="value"}>
		</TD>
	</TR>
	<TR id="a_discount">
		<TD style="width: 1%;{if ConfigHelper::checkConfig('privileges.hide_finances')} display: none;{/if}">
			<IMG src="img/value.gif" alt="">
		</TD>
		<TD style="width: 1%;{if ConfigHelper::checkConfig('privileges.hide_finances')} display: none;{/if}">
			<span class="bold">{trans("Discount:")}</span>
		</TD>
		<TD style="width: 98%;{if ConfigHelper::checkConfig('privileges.hide_finances')} display: none;{/if}">
			<INPUT type="text" size="8" name="assignment[discount]" value="{if $assignment.pdiscount != 0}{$assignment.pdiscount|string_format:"%.2f"}{else}{if $assignment.vdiscount != 0}{$assignment.vdiscount|string_format:"%.2f"}{/if}{/if}" {tip text="Enter discount percentage or amount" trigger="discount"}>
			<SELECT name="assignment[discount_type]">
				{foreach from=$_DISCOUNTTYPES item=item key=key}
					<OPTION value="{$key}"{if $assignment.discount_type == $key} selected{/if}>{$item}</OPTION>
				{/foreach}
			</SELECT>
		</TD>
	</TR>
	<TR id="a_tax">
		<TD style="width: 1%;">
			<IMG src="img/tax.gif" alt="">
		</TD>
		<TD style="width: 1%;">
			<span class="bold">{trans("Tax:")}</span>
		</TD>
		<TD style="width: 98%;">
			<SELECT SIZE="1" name="assignment[taxid]" {tip text="Select Tax value"}>
				{foreach item=tax from=$taxeslist}
					<OPTION value="{$tax.id}"{if ($assignment.taxid && $tax.id == $assignment.taxid) || (!$assignment.taxid && $tax.value == ConfigHelper::getConfig('phpui.default_taxrate'))} selected{/if}>{$tax.label}</OPTION>
				{/foreach}
			</SELECT>
		</TD>
	</TR>
	<TR id="a_productid">
		<TD style="width: 1%;">
			<IMG src="img/class.gif" alt="">
		</TD>
		<TD style="width: 1%;">
			<span class="bold">{trans("Product ID:")}</span>
		</TD>
		<TD style="width: 98%;">
			<INPUT type="text" name="assignment[prodid]" value="{$assignment.prodid}" size="10" {tip text="Enter liability Product ID (tariffless liabilities only)"}>
		</TD>
	</TR>
	<TR id="a_numberplan">
		<TD style="width: 1%;">
			<IMG src="img/id.gif" alt="">
		</TD>
		<TD style="width: 1%; white-space: nowrap;">
			<span class="bold">{trans("Numbering Plan:")}</span>
		</TD>
		<TD style="width: 98%;">
			<SELECT name="assignment[numberplanid]" {tip text="Select numbering plan"}>
				<OPTION value=""{if !$assignment.numberplanid} selected{/if}>- {trans("default")} -</OPTION>
				{foreach item=plan from=$numberplanlist}
				{assign var=period value=$plan.period}
				<OPTION value="{$plan.id}"{if $plan.id==$assignment.numberplanid} SELECTED{/if}>{$plan.template} ({$_NUM_PERIODS.$period})</OPTION>
				{/foreach}
			</SELECT>
		</TD>
	</TR>
	<TR id="a_paytype">
		<TD style="width: 1%;">
			<IMG src="img/print.gif" alt="">
		</TD>
		<TD style="width: 1%; white-space: nowrap;">
			<span class="bold">{trans("Payment Type:")}</span>
		</TD>
		<TD style="width: 98%;">
			<SELECT name="assignment[paytype]" {tip text="Select payment type" trigger="paytype"}>
				<OPTION value=""{if !$assignment.paytype} selected{/if}>- {trans("default")} -</OPTION>
				{foreach from=$_PAYTYPES item=item key=key}
				<OPTION value="{$key}"{if $assignment.paytype==$key} selected{/if}>{$item}</OPTION>
				{/foreach}
			</SELECT>
		</TD>
	</TR>
        <TBODY ID="adescom_assignments_panel">
            <TR>
			<TD colspan="3"><HR /></TD>
		</TR>
		<TR>
			<TD colspan="3" ID="adescom_assignments">
				{if $is_edit}
				{include file='customerassignments_adescom_liability_history_list.tpl'}
				{else}
			{include file='customerassignments_adescom_liability_add.tpl'}
				{/if}
			</TD>
		</TR>
        </TBODY>
	                    </TABLE>
                    </TD>
	                <TD style="width: 50%; vertical-align: top;">
	                    <TABLE style="width: 100%;" cellpadding="3">
	<TR id="a_options">
		<TD style="width: 1%;">
			<IMG src="img/options.gif" alt="">
		</TD>
		<TD style="width: 1%;">
			<B>{trans("Options:")}</B>
		</TD>
		<TD style="width: 98%;">
			<NOBR><INPUT type="checkbox" name="assignment[invoice]" value="1" id="invoice"{if $assignment.invoice} CHECKED{/if}><label for="invoice">{trans("with invoice")}</label></NOBR>
			<NOBR><INPUT type="checkbox" name="assignment[settlement]" value="1" id="settlement"{if $assignment.settlement} CHECKED{/if}><label for="settlement">{trans("with settlement of first deficient period")}</label></NOBR>
		</TD>
	</TR>
{if $customernodes}
	<TR id="a_nodes">
		<TD style="width: 1%;">
			<IMG src="img/node.gif" alt="">
		</TD>
		<TD style="width: 1%;">
			<span class="bold">{trans("Nodes:")}</span>
		</TD>
		<TD style="width: 98%; white-space: nowrap;" id="nodeslist">
			{section name=customernodes loop=$customernodes}
				{assign var=nodeid value=$customernodes[customernodes].id}
					<INPUT type="checkbox" name="assignment[nodes][{counter}]" value="{$customernodes[customernodes].id}" id="node{$customernodes[customernodes].id}" {if in_array($nodeid, (array)$assignment.nodes)} checked{/if}><label for="node{$customernodes[customernodes].id}"><B>{$customernodes[customernodes].name}</B> ({$customernodes[customernodes].id|string_format:"%04d"}){if $customernodes[customernodes].location} / {$customernodes[customernodes].location|truncate:"60":"...":true}{/if}</label>
					<BR>
			{/section}
			{if sizeof($customernodes) > 1}
				<INPUT TYPE="checkbox" NAME="allbox" onchange="CheckAll('nodeslist', this)" id="allnodes" VALUE="1"><label for="allnodes">{trans("check all<!items>")}</label>
			{/if}
		</TD>
	</TR>
{/if}
                        </TABLE>
                    </TD>
                </TR>
			</TABLE>
		</TD>
	</TR>
	<TR>
		<TD style="text-align: right;" colspan="3">
			<A href="javascript:document.assignment.submit()">{trans("Submit")} <IMG src="img/save.gif" alt=""></A>&nbsp;
			<A href="?m=customerinfo&id={$customerinfo.id}">{trans("Cancel")} <IMG src="img/cancel.gif" alt=""></A>
		</TD>
	</TR>
    </TBODY>
</TABLE>
</FORM>
<BR>
{include file="customer/customerassignments.html"}
<SCRIPT type="text/javascript">
<!--
var cal3 = new calendar(document.forms['assignment'].elements['assignment[datefrom]']);
cal3.time_comp = false;
var cal4 = new calendar(document.forms['assignment'].elements['assignment[dateto]']);
cal4.time_comp = false;
var cal5 = new calendar(document.forms['assignment'].elements['assignment[dateto]']);
cal5.time_comp = false;
set_tariff();
{if $promotionschemas}set_schema();{/if}
//-->
</SCRIPT>
{/block}
