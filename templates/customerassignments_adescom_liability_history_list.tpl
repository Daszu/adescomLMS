<TABLE width="100%" cellpadding="3">
    <TR>
        <TD width="1%">
            <IMG src="img/pay.gif" alt="">
        </TD>
        <TD width="1%" nowrap>
            <B>{t}Subscribe:{/t}</B>
        </TD>
        <TD width="98%">
            {if $adescom_liability.current_history}
            {$adescom_liability.current_history.price|money_format}
            &nbsp;<A HREF="#" ACCESSKEY="s" ONCLICK="xajax_adescom_add_assignment({$adescom_liability.clientid}, '{$adescom_liability.name}', 0);"><IMG src="img/add.gif" alt="[ {t}Add{/t} ]" title="[ {t}Add{/t} ]"></A>
            <INPUT type="checkbox" name="assignment[subscribe_settlement]" value="1" {if $adescom_liability.settlement}CHECKED{/if}> <A HREF="javascript:setCheckbox('assignment[subscribe_settlement]')">{t}with settlement of first deficient period{/t}</a></NOBR>		
            {else}
            {t}None{/t}&nbsp;<A HREF="#" ACCESSKEY="s" ONCLICK="xajax_adescom_add_assignment({$adescom_liability.clientid}, '{$adescom_liability.name}', 0);"><IMG src="img/add.gif" alt="[ {t}Add{/t} ]" title="[ {t}Add{/t} ]"></A>
            {/if}
        </TD>
    </TR>
    <TR>
        <TD width="1%">
            <IMG src="img/id.gif" alt="">
        </TD>
        <TD width="1%" nowrap>
            <B>{t}Changes history:{/t}</B>
        </TD>
        <TD width="98%">
            <TABLE width="100%" cellpadding="2" cellspacing="2">
                <thead>
                    <tr>
                        <td><b>{t}Date{/t}</b></td>
                        <td><b>{t}Price{/t}</b> ({$tariff_price_type})</td>
                        <td><b>{t}Commands{/t}</b></td>
                    </tr>					
                </thead>
                {section name=history loop=$adescom_liability.history}
                {assign var=history_entry value=$adescom_liability.history[history]}
                <TR>
                    <TD>
                        {if $history_entry.date > 0}
                        {$history_entry.date|date_format:"%Y-%m-%d"}</TD>					
                    {else}
                    {t}from the beginning{/t}
                    {/if}
                    <TD>{$history_entry.price|money_format}</TD>
                    <TD>
                        <A HREF="#" ONCLICK="xajax_adescom_delete_assignment({$adescom_liability.clientid}, '{$adescom_liability.name}', {$history_entry.id});"><IMG src="img/delete.gif" alt="[ {t}Delete{/t} ]" title="[ {t}Delete{/t} ]"></A>
                        <A HREF="#" ONCLICK="xajax_adescom_edit_assignment({$adescom_liability.clientid}, '{$adescom_liability.name}', {$history_entry.id}, 0);"><IMG src="img/edit.gif" alt="[ {t}edit{/t} ]" title="[ {t}Edit{/t} ]"></A>
                    </TD>
                </TR>
                {sectionelse}
                <TR>
                    <TD colspan="2" align="center">{t}No changes{/t}</TD>
                </TR>					
                {/section}
            </TABLE>			
        </TD>
    </TR>
</TABLE>