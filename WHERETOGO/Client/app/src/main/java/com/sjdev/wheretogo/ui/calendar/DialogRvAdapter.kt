package com.sjdev.wheretogo.ui.calendar

import android.content.Context
import android.content.Intent
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.sjdev.wheretogo.R
import com.sjdev.wheretogo.data.remote.calendar.CalendarResult
import com.sjdev.wheretogo.ui.detail.DetailActivity

import kotlin.collections.ArrayList

class DialogRvAdapter (var eventList: ArrayList<CalendarResult>, var con: Context?) : RecyclerView.Adapter<DialogRvAdapter.ViewHolder>()  {

    interface OnItemClickListener {
        fun onItemClick(thisDayEvent: CalendarResult)
    }
    private lateinit var mItemClickListener: OnItemClickListener

    fun setMyItemClickListener(itemClickListener: OnItemClickListener) {
        mItemClickListener = itemClickListener
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): DialogRvAdapter.ViewHolder {
        val con = parent.context
        val inflater = con.getSystemService(Context.LAYOUT_INFLATER_SERVICE) as LayoutInflater
        val view = inflater.inflate(R.layout.item_recycle_popup_dialog, parent, false)

        return ViewHolder(view) //아이템뷰 객체를 재활용하도록 뷰 홀더에게 던져줌
    }

    override fun onBindViewHolder(holder: DialogRvAdapter.ViewHolder, position: Int) {
        val event : CalendarResult = (eventList[position])
        holder.eventName.text = event.eventName

        holder.eventName.setOnClickListener {
            val intent = Intent(con, DetailActivity::class.java)
            intent.putExtra("eventIdx", event.eventID)
            con?.startActivity(intent)
        }

    }

    inner class ViewHolder(itemView: View): RecyclerView.ViewHolder(itemView){
        var type_of_event : View
        var eventName : TextView

        init{
            type_of_event=itemView.findViewById(R.id.type_of_event_view)
            eventName=itemView.findViewById(R.id.eventName)
        }

    }


    override fun getItemCount(): Int {
        return eventList.size
    }

    override fun getItemId(position: Int): Long {
        return position.toLong()
    }


}