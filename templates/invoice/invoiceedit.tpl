{extends file="layout.html"}
{block name=title}::: LMS :{$layout.pagetitle|striphtml} :::{/block}
{block name=module_content}
{$xajax}
<!--// $Id$ //-->
<H1>{$layout.pagetitle}</H1>
{include file="calendar_js.html"}
<script type="text/javascript">
<!--
	function setItem(index)
	{
		var e = document.additem;
		{foreach from=$tariffs item=tariff}
		if (index == {$tariff.id})
		{
			e.name.value = '{$tariff.name|escape}';
			e.taxid.value = '{$tariff.taxid}';
			e.valuebrutto.value = '{$tariff.value}';
			e.prodid.value = '{$tariff.prodid}';
			e.tariffid.value = '{$tariff.id}';
			e.count.value = 1;
			return;
		}
		{/foreach}
		if (index == 0)
		{
			e.name.value = '';
			e.valuebrutto.value = '';
			e.prodid.value = '';
			e.tariffid.value = '';
			e.count.value = 1
		}
	}

	function saveheader()
	{
		if (document.setcustomer.customer)
			if (document.setcustomer.customer.value != 0)
				document.setcustomer.customerid.value = document.setcustomer.customer.value;

		document.setcustomer.submit();
	}

	function reset_customer()
	{
		if (document.setcustomer.customerid.value)
			document.setcustomer.customer.value = document.setcustomer.customerid.value;
	}

	function setType(type)
	{
		document.additem.elements[type].checked = !document.additem.elements[type].checked;
	}

	function printinvoice()
	{
		var add = "";
		if(document.additem.original.checked)
		        add += "&original=1";
		if(document.additem.copy.checked)
			add += "&copy=1";
		if(document.additem.duplicate.checked)
			add += "&duplicate=1";

		document.additem.action = "?m=invoiceedit&action=save&print=1" + add;
		document.additem.submit();
	}

	function setProduct(name, prodid, count, jm, discount, discount_type, valuenetto, taxid, valuebrutto)
	{
	    var form = document.additem;

		form.name.value = name;
		form.prodid.value = prodid;
		form.count.value = count;
		form.jm.value = jm;
		form.discount.value = discount;
		form.discount_type.selectedIndex = discount_type;
		form.valuenetto.value = valuenetto;
		form.taxid.value = taxid;
		form.valuebrutto.value = valuebrutto;
	}

	function deadline_calendar(elem)
	{
		var ts = get_cdate(), deadline = parseInt(elem.value);

		// add paytime days to settlement date
		ts.setDate(ts.getDate() + (deadline || 0));
		// display calendar
		cal3.popup(cal3.gen_date(ts));
	 }

	function get_cdate()
	{
		var ts = document.setcustomer.elements['invoice[cdate]'].value;

		if (!ts.match(/^[0-9]{4}\/[0-9]{2}\/[0-9]{2}$/))
			ts = '{$smarty.now|date_format:"%Y/%m/%d"}';

		return cal3.prs_date(ts);
	}

//-->
</script>
{$default_printpage = ConfigHelper::getConfig('invoices.default_printpage')}
{$default_taxrate   = ConfigHelper::getConfig('phpui.default_taxrate')}
<FORM NAME="setcustomer" METHOD="POST" ACTION="?m=invoiceedit&action=setcustomer">
<INPUT type="submit" class="hiddenbtn">
<INPUT type="HIDDEN" name="invoice[number]" value="{$invoice.number}">
<INPUT type="HIDDEN" name="invoice[template]" value="{$invoice.template}">
<TABLE class="lmsbox">
    <THEAD>
	<TR>
		<TD WIDTH="100%" COLSPAN="2">
			<B>{trans("Main Information:")}</B>
		</TD>
	</TR>
    </THEAD>
    <TBODY>
	<TR>
		<TD WIDTH="1%" NOWRAP>
			<B>{trans("Settlement date:")}</B>
		</TD>
		<TD WIDTH="99%" NOWRAP>
			<INPUT TYPE="TEXT" NAME="invoice[cdate]" VALUE="{$invoice.cdate|date_format:"%Y/%m/%d"}" SIZE="10" {tip text="Enter date of settlement in YYYY/MM/DD format (empty field means current date) or click to select it from calendar" trigger="cdate"} OnClick="javascript:cal1.popup();" >
			{if $invoice.cdatewarning}
			<INPUT TYPE="HIDDEN" NAME="invoice[cdatewarning]" VALUE="1">
			{/if}
		</TD>
	</TR>
	<TR>
		<TD WIDTH="1%" NOWRAP>
			<B>{trans("Sale date:")}</B>
		</TD>
		<TD WIDTH="99%" NOWRAP>
			<INPUT TYPE="TEXT" NAME="invoice[sdate]" VALUE="{$invoice.sdate|date_format:"%Y/%m/%d"}" SIZE="10" {tip text="Enter date of sale in YYYY/MM/DD format (empty field means current date) or click to select it from calendar" trigger="sdate"} OnClick="javascript:cal2.popup();" >
		</TD>
	</TR>
	<TR>
		<TD WIDTH="1%" NOWRAP>
			<B>{trans("Deadline:")}</B>
		</TD>
		<TD WIDTH="99%" NOWRAP>
			<INPUT TYPE="TEXT" NAME="invoice[paytime]" VALUE="{$invoice.paytime}" SIZE="5" ID="paytime" onclick="deadline_calendar(this)" {tip text="Enter deadline in days (optional)"}>
		</TD>
	</TR>
	<TR>
		<TD WIDTH="1%" NOWRAP>
			<B>{trans("Payment type (cash/transfer/etc):")}</B>
		</TD>
		<TD WIDTH="99%" NOWRAP>
			<SELECT name="invoice[paytype]" {tip text="Select payment type" trigger="paytype"}>
				{foreach from=$_PAYTYPES item=item key=key}
				<OPTION value="{$key}"{if $invoice.paytype==$key} selected{/if}>{$item}</OPTION>
				{/foreach}
			</SELECT>
		</TD>
	</TR>
	<TR>
		<TD WIDTH="1%" NOWRAP>
			<B>{trans("Customer:")}</B>
		</TD>
		<TD WIDTH="99%" NOWRAP>
			{if $customers}
			<SELECT SIZE="1" NAME="customer" onChange="document.setcustomer.customerid.value=document.setcustomer.customer.value">
				<OPTION VALUE="0">{trans("... select customer ...")}</OPTION>
				{foreach from=$customers item=c}
				<OPTION VALUE="{$c.id}"{if $c.id == $customer.id || $invoice.customerid == $c.id} SELECTED{/if}>{$c.customername|truncate:"40":"...":true} ({$c.id|string_format:"%04d"})</OPTION>
				{/foreach}
			</SELECT>
			{trans("or Customer ID:")}
			{/if}
			<INPUT TYPE="TEXT" NAME="customerid" VALUE="{if $customer.id}{$customer.id}{else}{$invoice.customerid}{/if}" SIZE="5"{if $customers} onChange="reset_customer()" onfocus="reset_customer()"{/if} {tip text="Enter customer ID"}>
			<a href="javascript: void(0);" onClick="return customerchoosewin(document.setcustomer.customerid);" {tip text="Click to search customer"}>{trans("Search")}&nbsp;&raquo;&raquo;&raquo;</A>
		</TD>
	</TR>
	<TR>
		<TD WIDTH="100%" ALIGN="right" COLSPAN="2">
			<A HREF="javascript: saveheader();">{trans("Submit")} <IMG SRC="img/save.gif" ALT=""></A>
		</TD>
	</TR>
    </TBODY>
</TABLE>
</FORM>
{if $customer}
<BR>
<TABLE class="lmsbox">
    <THEAD>
        <TR>
                <TD WIDTH="1%" nowrap>
                        <IMG SRC="img/customer.gif" ALT=""> <B>{trans("Customer:")}</B>
                </TD>
                <TD WIDTH="99%">
                        <B>{$customer.customername}</B>
                        &nbsp;&raquo;&nbsp; {$customer.address} &nbsp; {$customer.zip} {$customer.city}
                        &nbsp;&raquo;&nbsp; {if $customer.balance < 0}<FONT class="red">{/if}{$customer.balance|money_format}{if $customer.balance < 0}</FONT>{/if}
                </TD>
        </TR>
    </THEAD>
</TABLE>
{/if}
<BR>
<TABLE class="lmsbox">
    <THEAD>
	<TR>
		<TD WIDTH="1%">
			<B>{trans("No.")}</B>
		</TD>
		<TD WIDTH="92%">
			{trans("Name of product, commodity or service:")}
		</TD>
		<TD WIDTH="1%" nowrap>
			{trans("Product ID:")}
		</TD>
		<TD WIDTH="1%" ALIGN="RIGHT">
			{trans("Amount:")}<BR>
			{trans("Unit:")}
		</TD>
		<TD WIDTH="1%" NOWRAP ALIGN="RIGHT">
			{trans("Discount:")}
		</TD>
		<TD WIDTH="1%" NOWRAP ALIGN="RIGHT">
			{trans("Net Price:")}<BR>
			{trans("Net Value:")}
		</TD>
		<TD WIDTH="1%" ALIGN="RIGHT">
			{trans("Tax:")}
		</TD>
		<TD WIDTH="1%" NOWRAP ALIGN="RIGHT">
			{trans("Gross Price:")}<BR>
			{trans("Gross Value:")}
		</TD>
		<TD WIDTH="1%">
			&nbsp;
		</TD>
	</TR>
    </THEAD>
    <TBODY>
	{cycle values="light,lucid" print=false}
	{foreach from=$contents item=item}
	<TR class="highlight {cycle}"  {if !$invoice.closed} onclick="setProduct('{$item.name}', '{$item.prodid}', '{$item.count|string_format:"%.2f"}', '{$item.jm}', {if $item.pdiscount != 0}'{$item.pdiscount|string_format:"%.2f"}', {$smarty.const.DISCOUNT_PERCENTAGE - 1}{else}{if $item.vdiscount != 0}'{$item.vdiscount|string_format:"%.2f"}', {$smarty.const.DISCOUNT_AMOUNT - 1}{else}'', {$smarty.const.DISCOUNT_PERCENTAGE - 1}{/if}{/if}, '{$item.valuenetto|string_format:"%.2f"}', {foreach item=tax from=$taxeslist}{if $tax.label == $item.tax}{$tax.id}{/if}{/foreach}, '{$item.valuebrutto|string_format:"%.2f"}');"{/if}>
		<TD WIDTH="1%">
			<B>{counter}.</B>
		</TD>
		<TD WIDTH="92%">
			{$item.name}
		</TD>
		<TD WIDTH="1%" NOWRAP>
			{$item.prodid}
		</TD>
		<TD WIDTH="1%" NOWRAP ALIGN="RIGHT">
			{$item.count|string_format:"%.2f"}<BR>
			{$item.jm}
		</TD>
		<TD WIDTH="1%" NOWRAP ALIGN="RIGHT">
			{if $item.pdiscount != 0}{$item.pdiscount|string_format:"%.2f %%"}{else}{if $item.vdiscount != 0}{$item.vdiscount|money_format}{/if}{/if}
		</TD>
		<TD WIDTH="1%" NOWRAP ALIGN="RIGHT">
			{$item.valuenetto|money_format}<BR>
			{$item.s_valuenetto|money_format}
		</TD>
		<TD WIDTH="1%" NOWRAP ALIGN="RIGHT">
			{$item.tax}
		</TD>
		<TD WIDTH="1%" NOWRAP ALIGN="RIGHT">
			{$item.valuebrutto|money_format}<BR>
			{$item.s_valuebrutto|money_format}
		</TD>
		<TD WIDTH="1%" NOWRAP>
            {if !$invoice.closed}
			<A HREF="?m=invoiceedit&action=deletepos&posuid={$item.posuid}"><IMG SRC="img/delete.gif" {tip text="Remove this item from list"}></A>
		    {/if}
		</TD>
	</TR>
	{foreachelse}
	<TR>
		<TD COLSPAN="9" ALIGN="CENTER">
			<p>&nbsp;</p>
			<p><B>{trans("Invoice have no items. Use form below for items addition.")}</B></p>
			<p>&nbsp;</p>
		</TD>
	</TR>
	{/foreach}
	{if $contents}
	<TR>
		<TD COLSPAN="5" WIDTH="96%" ALIGN="RIGHT">
			<B>{trans("Total:")}</B>
		</TD>
		<TD WIDTH="1%" NOWRAP ALIGN="RIGHT">
			<B>{sum array=$contents column=s_valuenetto string_format="%01.2f"}</B>
		</TD>
		<TD WIDTH="1%">
			&nbsp;
		</TD>
		<TD WIDTH="1%" NOWRAP ALIGN="RIGHT">
			<B>{sum array=$contents column=s_valuebrutto string_format="%01.2f"}</B>
		</TD>
		<TD WIDTH="1%">
			&nbsp;
		</TD>
	</TR>
	{/if}
    </TBODY>
    <TFOOT>
	<FORM METHOD="POST" ACTION="?m=invoiceedit&action=additem" NAME="additem">
	<INPUT type="submit" class="hiddenbtn">
	<INPUT TYPE="HIDDEN" NAME="tariffid" VALUE="0">
	{if !$invoice.closed}
	<TR>
		<TD WIDTH="1%" NOWRAP>
			<B>{counter}.</B>
		</TD>
		<TD WIDTH="92%" NOWRAP>
			<INPUT TYPE="text" NAME="name" SIZE="40" style="width:300px" {tip text="Enter description or select tariff from the list"}><BR>
			<SELECT SIZE="1" NAME="ttariffid" style="width: 300px" onchange="setItem(document.additem.ttariffid.value)" {tip text="Enter description or select tariff from the list"}>
				<OPTION value="0">-</OPTION>
				{foreach from=$tariffs item=tariff}
				<OPTION VALUE="{$tariff.id}">{$tariff.name} ({$tariff.value|money_format})</OPTION>
				{/foreach}
			</SELECT>
		</TD>
		<TD ALIGN="RIGHT">
			<INPUT TYPE="text" NAME="prodid" SIZE="6">
		</TD>
		<TD ALIGN="RIGHT">
			<INPUT TYPE="text" NAME="count" SIZE="3" VALUE="1">
			<INPUT TYPE="text" NAME="jm" SIZE="3" VALUE="{trans("pcs.")}">
		</TD>
		<TD ALIGN="RIGHT">
			<INPUT TYPE="text" NAME="discount" SIZE="6" {tip text="Enter discount percentage or amount"}>
			<SELECT name="discount_type">
				{foreach from=$_DISCOUNTTYPES item=item key=key}
					<OPTION value="{$key}">{$item}</OPTION>
				{/foreach}
			</SELECT>
		</TD>
		<TD ALIGN="RIGHT" NOWRAP>
			<INPUT TYPE="text" NAME="valuenetto" SIZE="6" {tip text="Enter unitary value without discount"}>
		</TD>
		<TD ALIGN="RIGHT" NOWRAP>
			<SELECT size="1" name="taxid" {tip text="Select Tax rate"}>
			{foreach item=tax from=$taxeslist}
				<OPTION value="{$tax.id}"{if $tax.value == $default_taxrate} selected{/if}>{$tax.label}</OPTION>
			{/foreach}
			</SELECT>
		</TD>
		<TD ALIGN="RIGHT" NOWRAP>
			<INPUT TYPE="text" NAME="valuebrutto" SIZE="6" {tip text="Enter unitary value without discount"}>
		</TD>
		<TD>
			<A HREF="javascript:document.additem.submit(); "><IMG SRC="img/save.gif" ALT="" {tip text="Add item"}></A>
		</TD>
	</TR>
	{/if}
 	{if $adescom}
 	<TR CLASS="light">
 		<TD WIDTH="100%" CLASS="ftl ftr" ALIGN="CENTER" NOWRAP COLSPAN="9">
 			<BR>
 			<SELECT SIZE="1" NAME="extraposition_details[type]" style="width: 300px">
 				{foreach from=$extrapositions item=position}
 				<OPTION VALUE="{$position.type}">{t}{$position.name}{/t}</OPTION>
 				{/foreach}
 			</SELECT>
 			&nbsp;{t}from{/t}&nbsp;<INPUT TYPE="TEXT" NAME="extraposition_details[fromdate]" VALUE="{$extraposition.fromdate|date_format:"%Y/%m/%d"}" SIZE="10" {tip text="Enter from date for extra position (empty field means current date)" trigger="extrafromdate"} OnClick="javascript:cal_fromdate.popup();" >
 			&nbsp;{t}to{/t}&nbsp;<INPUT TYPE="TEXT" NAME="extraposition_details[todate]" VALUE="{$extraposition.todate|date_format:"%Y/%m/%d"}" SIZE="10" {tip text="Enter to date for extra position (empty field means current date)" trigger="extratodate"} OnClick="javascript:cal_todate.popup();" >
 			<A HREF="#" ONCLICK="get_extra_position()">{t}Get{/t}</A>
 			{literal}
 			<SCRIPT type="text/javascript">
 				<!--
 				var cal_fromdate = new calendar(document.forms['additem'].elements['extraposition_details[fromdate]']);
 				cal_fromdate.time_comp = false;
 				var cal_todate = new calendar(document.forms['additem'].elements['extraposition_details[todate]']);
 				cal_todate.time_comp = false;
 				
 				function get_extra_position()
 				{
 					var type = document.forms['additem'].elements['extraposition_details[type]'].value;
 					var date_from = document.forms['additem'].elements['extraposition_details[fromdate]'].value;
 					var date_to = document.forms['additem'].elements['extraposition_details[todate]'].value;
 					var customer_id = document.forms['setcustomer'].elements['customerid'].value;
 					
 					xajax_get_extra_position(type, date_from, date_to, customer_id);
 				}
 				//-->
 			</SCRIPT>
 			{/literal}
 		</TD>
 	</TR>
 	<TR CLASS="light">
 		<TD ID="extra_positions" WIDTH="100%" ALIGN="CENTER" NOWRAP COLSPAN="9"></TD>
 	</TR>	
 	{/if}
	<TR>
		<TD COLSPAN="9" ALIGN="RIGHT">
			<INPUT type="checkbox" name="original"{if preg_match('/original/i', $default_printpage)} checked{/if}> <A HREF="javascript:setType('original');">{trans("original")}</A>
	        <INPUT type="checkbox" name="copy"{if preg_match('/copy/i', $default_printpage)} checked{/if}> <A HREF="javascript:setType('copy');">{trans("copy")}</A>
			<INPUT type="checkbox" name="duplicate"{if preg_match('/duplicate/i', $default_printpage)} checked{/if}> <A HREF="javascript:setType('duplicate');">{trans("duplicate")}</A>&nbsp;
			<A HREF="?m=invoicelist">{trans("Cancel")} <IMG src="img/cancel.gif"></A> 
			{if !$customer}
			<A HREF="javascript:alert('{trans("Customer not selected!")}');">{trans("Save")} <IMG src="img/save.gif" alt=""></A>
			<A HREF="javascript:alert('{trans("Customer not selected!")}');">{trans("Save & Print")} <IMG src="img/print.gif" alt=""></A>
			{elseif !$contents}
			<A HREF="javascript:alert('{trans("Invoice have no items!")}');">{trans("Save")} <IMG src="img/save.gif" alt=""></A>
			<A HREF="javascript:alert('{trans("Invoice have no items!")}');">{trans("Save & Print")} <IMG src="img/print.gif" alt=""></A>
			{else}
			<A HREF="?m=invoiceedit&action=save">{trans("Save")} <IMG src="img/save.gif" alt=""></A>
			<A HREF="javascript:printinvoice()">{trans("Save & Print")} <IMG src="img/print.gif" alt=""></A>
			{/if}
		</TD>
	</TR>
	</FORM>
    </TFOOT>
</TABLE>
<SCRIPT type="text/javascript">
<!--
deadline_callback = function(val)
{
	var ts = get_cdate(), deadline = cal3.prs_date(val);
	deadline = parseInt((deadline - ts) / 86400000);
	document.getElementById('paytime').value = deadline <= 0 ? '' : deadline;
}
var cal1 = new calendar(document.forms['setcustomer'].elements['invoice[cdate]']);
cal1.time_comp = false;
var cal2 = new calendar(document.forms['setcustomer'].elements['invoice[sdate]']);
cal2.time_comp = false;
var cal3 = new calendar(deadline_callback);
cal3.time_comp = false;
document.forms['setcustomer'].elements['invoice[cdate]'].focus();
//-->
</SCRIPT>
{/block}
